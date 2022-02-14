import JWT
import Vapor
import Foundation

public extension Application.SignInWithApple {
    
    struct Client {
        
        public enum Authorization { }
        
        enum Validation { }
        
        let clientID: String
        
        let teamID: String
        
        let secretKeyID: JWKIdentifier
        
        let secretKeySigner: JWTSigner
    }
}

public extension Application.SignInWithApple.Client {
    
    func signIn(
        with credential: Application.SignInWithApple.UnverifiedCredential,
        on req: Request
    ) async throws -> Application.SignInWithApple.AuthorizedCredential {
        _ = try await verify(credential.identityToken, on: req)
        let body = RequestBody(
            clientID: clientID,
            clientSecret: try clientSecret,
            grantType: .authorizationCode(credential.authorizationCode)
        )
        typealias TokenResponse = Application.SignInWithApple.AuthorizationCodeValidation.TokenResponse
        let tokenResponse = try await send(body: body, on: req, receive: TokenResponse.self)
        let identityToken = try await verify(tokenResponse.idToken, on: req)
        return .init(identityToken: identityToken, tokenResponse: tokenResponse)
    }
    
    func validateRefreshToken(
        _ refreshToken: Application.SignInWithApple.RefreshToken,
        on req: Request
    ) async throws -> Application.SignInWithApple.AuthorizedCredential {
        let body = RequestBody(
            clientID: clientID,
            clientSecret: try clientSecret,
            grantType: .refreshToken(refreshToken.value)
        )
        typealias TokenResponse = Application.SignInWithApple.RefreshTokenValidation.TokenResponse
        let tokenResponse = try await send(body: body, on: req, receive: TokenResponse.self)
        return .init(unvalidatedRefreshToken: refreshToken, tokenResponse: tokenResponse)
    }
}

fileprivate extension Application.SignInWithApple.Client {
    
    func verify(_ identityToken: String, on req: Request) async throws -> AppleIdentityToken {
        let jwt = req.application.jwt
        let jwks = try await jwt.apple.jwks.get(on: req).get()
        try jwt.signers.use(jwks: jwks)
        return try jwt.signers.verify(identityToken, as: AppleIdentityToken.self)
    }
    
    func send<TokenResponse: Decodable>(
        body: RequestBody,
        on req: Request,
        receive tokenResponseType: TokenResponse.Type
    ) async throws -> TokenResponse {
        let url = "https://appleid.apple.com/auth/token"
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/x-www-form-urlencoded")
        let request = try HTTPClient.Request(url: url, method: .POST, headers: headers, body: .data(body.data))
        let response = try await req.application.http.client.shared.execute(request: request).get()
        let decoder = JSONDecoder()
        guard let body = response.body else {
            throw Abort(.badRequest, reason: "The Apple server failed to respond.")
        }
        do {
            return try decoder.decode(tokenResponseType, from: body)
        }
        catch {
            guard let appleError = try? decoder.decode(AppleServerError.self, from: body) else {
                throw error
            }
            throw appleError
        }
    }
}


// MARK: - Client Secret

fileprivate extension Application.SignInWithApple.Client {
    
    var clientSecret: String {
        get throws {
            let secret = Application.SignInWithApple.Client.ClientSecret(teamID: teamID, clientID: clientID)
            try secret.verify(using: secretKeySigner)
            return try secretKeySigner.sign(secret, kid: secretKeyID)
        }
    }
    
    struct ClientSecret: JWTPayload {
        
        enum CodingKeys: String, CodingKey {
            case issuer = "iss"
            case issuedAt = "iat"
            case expires = "exp"
            case audience = "aud"
            case subject = "sub"
        }
        
        let issuer: IssuerClaim
        
        let issuedAt: IssuedAtClaim
        
        let expires: ExpirationClaim
        
        let audience: AudienceClaim = "https://appleid.apple.com"
        
        let subject: SubjectClaim
        
        init(
            teamID: String,
            issuedAt: IssuedAtClaim = .init(value: Date().addingTimeInterval(-60)),
            validDuration: TimeInterval = 600,
            clientID: String
        ) {
            issuer = IssuerClaim(value: teamID)
            self.issuedAt = issuedAt
            expires = ExpirationClaim(value: issuedAt.value.addingTimeInterval(validDuration))
            subject = SubjectClaim(value: clientID)
        }
        
        func verify(using signer: JWTSigner) throws {
            try expires.verifyNotExpired()
        }
    }
}


// MARK: - Request Body

extension Application.SignInWithApple.Client {
    
    struct RequestBody {
        
        let clientID: String
        
        let clientSecret: String
        
        let grantType: GrantType
        
        enum GrantType {
            case authorizationCode(String)
            case refreshToken(String)
            
            var queryItems: [URLQueryItem] {
                switch self {
                case .authorizationCode(let code): return [
                    .init(name: "code", value: code),
                    .init(name: "grant_type", value: "authorization_code"),
                ]
                case .refreshToken(let token): return [
                    .init(name: "refresh_token", value: token),
                    .init(name: "grant_type", value: "refresh_token")
                ]
                }
            }
        }
        
        var data: Data {
            let queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "client_secret", value: clientSecret),
            ]
            var components = URLComponents()
            components.queryItems =  queryItems + grantType.queryItems
            return components.query?.data(using: .utf8) ?? .init()
        }
    }
}


// MARK: - Apple Server Error

public extension Application.SignInWithApple.Client {
    
    struct AppleServerError: Hashable, Equatable, Decodable, AbortError {
        
        public let errorType: ErrorType
        
        private let errorDescription: String?
        
        private enum CodingKeys: String, CodingKey {
            case error
            case errorDescription = "error_description"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            errorType = ErrorType(rawValue: try container.decode(String.self, forKey: .error))
            errorDescription = try container.decodeIfPresent(String.self, forKey: .errorDescription)
        }
        
        public var reason: String { errorDescription ?? errorType.description }
        
        public var status: HTTPResponseStatus { .badRequest }
    }
}

public extension Application.SignInWithApple.Client.AppleServerError {
    
    struct ErrorType: RawRepresentable, Hashable, Equatable, CustomStringConvertible {
        
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let invalidRequest = Self(rawValue: "invalid_request")
        
        public static let invalidClient = Self(rawValue: "invalid_client")
        
        public static let invalidGrant = Self(rawValue: "invalid_grant")
        
        public static let unauthorizedClient = Self(rawValue: "unauthorized_client")
        
        public static let unsupportedGrantType = Self(rawValue: "unsupported_grant_type")
        
        public static let invalidScope = Self(rawValue: "invalid_scope")
        
        public var description: String {
            switch self {
            case .invalidRequest:
                return "The request is malformed, normally due to a missing parameter, contains an unsupported parameter, includes multiple credentials, or uses more than one mechanism for authenticating the client."
            case .invalidClient:
                return "The client authentication failed."
            case .invalidGrant:
                return "The authorization grant or refresh token is invalid."
            case .unauthorizedClient:
                return "The client is not authorized to use this authorization grant type."
            case .unsupportedGrantType:
                return "The authenticated client is not authorized to use the grant type."
            case .invalidScope:
                return "The requested scope is invalid."
            default:
                return ""
            }
        }
    }
}
