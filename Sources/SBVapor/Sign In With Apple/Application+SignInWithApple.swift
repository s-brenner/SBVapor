import JWT
import Vapor

extension Application {
    
    public struct SignInWithApple {
        
        public func initialize() throws {
            let clientID = try Environment.value(forKey: "SIGNINWITHAPPLE_CLIENTID")
            let teamID = try Environment.value(forKey: "SIGNINWITHAPPLE_TEAMID")
            guard teamID.count == 10 else { throw Error.teamIDInvalid(value: teamID) }
            let _secretKeyID = try Environment.value(forKey: "SIGNINWITHAPPLE_KEYID")
            guard _secretKeyID.count == 10 else { throw Error.secretKeyIDInvalid(value: _secretKeyID) }
            let secretKeyID = JWKIdentifier(string: _secretKeyID)
            let secretKey = try Environment.value(forKey: "SIGNINWITHAPPLE_KEY")
            do {
                let secretKeySigner = try JWTSigner.es256(key: .private(pem: secretKey.bytes))
                application.storage[Key.self] = Storage(
                    clientID: clientID,
                    teamID: teamID,
                    secretKeyID: secretKeyID,
                    secretKeySigner: secretKeySigner
                )
                application.logger.notice("SignInWithApple initialized")
            }
            catch {
                guard let error = error as? JWTError else { throw error }
                throw Error.secretKeyInvalid(error)
            }
        }
        
        fileprivate let application: Application
        
        public var client: Client {
            Client(
                clientID: storage.clientID,
                teamID: storage.teamID,
                secretKeyID: storage.secretKeyID,
                secretKeySigner: storage.secretKeySigner
            )
        }
    }
    
    public var signInWithApple: SignInWithApple { .init(application: self) }
}

private extension Application.SignInWithApple {
    
    final class Storage {
        
        let clientID: String
        
        let teamID: String
        
        let secretKeyID: JWKIdentifier
        
        let secretKeySigner: JWTSigner
        
        init(clientID: String, teamID: String, secretKeyID: JWKIdentifier, secretKeySigner: JWTSigner) {
            self.clientID = clientID
            self.teamID = teamID
            self.secretKeyID = secretKeyID
            self.secretKeySigner = secretKeySigner
        }
    }
    
    struct Key: StorageKey {
        typealias Value = Storage
    }
    
    var storage: Storage {
        if application.storage[Key.self] == nil {
            do { try initialize() }
            catch { fatalError(error.localizedDescription) }
        }
        return application.storage[Key.self]!
    }
}


// MARK: - Error

public extension Application.SignInWithApple {
    
    enum Error: LocalizedError {
        case teamIDInvalid(value: String)
        case secretKeyIDInvalid(value: String)
        case secretKeyInvalid(_ error: JWTError)
        
        public var errorDescription: String? {
            var string = "SignInWithAppleError"
            if let reason = failureReason {
                string += "\n\t\(reason)"
            }
            if let recovery = recoverySuggestion {
                string += "\n\t\(recovery)"
            }
            return string
        }
        
        public var failureReason: String? {
            switch self {
            case .teamIDInvalid(let value):
                return "The team ID (\(value)) is invalid"
            case .secretKeyIDInvalid(let value):
                return "The secret key ID (\(value)) is invalid"
            case .secretKeyInvalid(let error):
                return error.reason
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            case .teamIDInvalid:
                return "The team ID from your Apple Developer account must be 10 characters"
            case .secretKeyIDInvalid:
                return "The secret key ID from your Apple Developer account must be 10 characters"
            case .secretKeyInvalid(let error):
                return error.recoverySuggestion
            }
        }
    }
}

extension Application.SignInWithApple {
    
    struct VerifiedCredential: Content {
        
        private let credential: UnverifiedCredential
        
        let identityToken: AppleIdentityToken
        
        var rawIdentityToken: String { credential.identityToken }
        
        var userIdentifier: String { credential.userIdentifier }
        
        var authorizationCode: String { credential.authorizationCode }
        
        init(credential: UnverifiedCredential, token: AppleIdentityToken) {
            self.credential = credential
            identityToken = token
        }
    }
    
    enum AuthorizationCodeValidation { }
    
    enum RefreshTokenValidation { }
}

extension Application.SignInWithApple.AuthorizationCodeValidation {
    
    struct TokenResponse: TokenResponseRepresentable, Decodable, Content {
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case idToken = "id_token"
            case refreshToken = "refresh_token"
            case tokenType = "token_type"
        }
        
        let accessToken: String
        
        let expiresIn: Int
        
        let tokenType: String
        
        /// A JSON Web Token that contains the user’s identity information.
        let idToken: String
        
        /// The refresh token used to regenerate new access tokens. Store this token securely on your server.
        let refreshToken: String
    }
}

extension Application.SignInWithApple.RefreshTokenValidation {
    
    struct TokenResponse: TokenResponseRepresentable, Decodable, Content {
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case tokenType = "token_type"
        }
        
        let accessToken: String
        
        let expiresIn: Int
        
        let tokenType: String
    }
}
