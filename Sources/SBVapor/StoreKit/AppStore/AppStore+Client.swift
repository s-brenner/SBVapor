import JWT
import Vapor
import Foundation

public extension Application.AppStore {
    
    struct Client {
        
        let httpClient: HTTPClient
        
        let issuerId: String
        
        let bundleId: String
        
        let privateKeyId: JWKIdentifier
        
        let privateKey: ECDSAKey
    }
}

public extension Application.AppStore.Client {
    
//    func getTransactionHistory(
//        environment: Application.AppStore.Environment = .production,
//        originalTransactionID: String,
//        revision: String? = nil
//    ) async throws -> Application.AppStore.HistoryResponse {
//        try await makeServerAPIRequest(
//            endpoint: .transactionHistory(revision: revision),
//            environment: environment,
//            originalTransactionID: originalTransactionID
//        )
//    }
    
//    func getSubscriptionStatuses(
//        environment: Application.AppStore.Environment = .production,
//        originalTransactionID: String
//    ) async throws -> Application.AppStore.StatusResponse  {
//        try await makeServerAPIRequest(
//            endpoint: .subscriptionStatuses,
//            environment: environment,
//            originalTransactionID: originalTransactionID
//        )
//    }
    
    enum AppStoreError: AbortError {
        case unauthorized
        case appleServerError(AppleServerError)
        case internalServerError
        
        public struct AppleServerError: Decodable {
            
            public let errorCode: Int
            
            public let errorMessage: String
        }
        
        public var reason: String {
            switch self {
            case .unauthorized: return "The request is unauthorized; the JSON Web Token (JWT) is invalid."
            case .appleServerError(let error): return error.errorMessage
            case .internalServerError: return "An unknown error occurred."
            }
        }
        
        public var status: HTTPStatus {
            switch self {
            case .unauthorized: return .unauthorized
            case .appleServerError(let error):
                let prefix = "\(error.errorCode)".prefix(3)
                switch prefix {
                case "400": return .badRequest
                case "404": return .notFound
                case "500": return .internalServerError
                default: return .custom(code: UInt(error.errorCode), reasonPhrase: error.errorMessage)
                }
            case .internalServerError: return .internalServerError
            }
        }
    }
}

fileprivate extension Application.AppStore.Client {
    
    enum Endpoint {
        case transactionHistory(revision: String?)
        case subscriptionStatuses
    }
    
    func makeServerAPIRequest<T: Decodable>(
        endpoint: Endpoint,
        environment: Application.AppStore.Environment,
        originalTransactionID: String
    ) async throws -> T {
        let url = URL.appStoreServer(endpoint: endpoint, environment: environment, originalTransactionID: originalTransactionID)
        let headers = HTTPHeaders.make(signedToken: try signedToken())
        let request = try HTTPClient.Request(url: url, method: .GET, headers: headers)
        let response = try await httpClient.execute(request: request).get()
        if response.status == .unauthorized {
            throw AppStoreError.unauthorized
        }
        else if response.status == .ok, let body = response.body {
            return try JSONDecoder().decode(T.self, from: body)
        }
        else if let body = response.body {
            let error = try JSONDecoder().decode(AppStoreError.AppleServerError.self, from: body)
            throw AppStoreError.appleServerError(error)
        }
        throw AppStoreError.internalServerError
    }
}

fileprivate extension Application.AppStore.Client {
    
    func signedToken() throws -> String {
        try ServerAPIToken
            .Payload(issuerID: issuerId, bundleID: bundleId)
            .signed(keyID: privateKeyId, key: privateKey)
    }
    
    enum ServerAPIToken {
        
        struct Payload: JWTPayload, Equatable {
            
            enum CodingKeys: String, CodingKey {
                case issuer = "iss"
                case issuedAt = "iat"
                case expiration = "exp"
                case audience = "aud"
                case nonce
                case bundleID = "bid"
            }
            
            let issuer: IssuerClaim
            
            let issuedAt: IssuedAtClaim
            
            let expiration: ExpirationClaim
            
            let audience: AudienceClaim
            
            let nonce: String
            
            let bundleID: String
            
            init(
                issuerID issuer: String,
                issuedAt: Date = Date(),
                bundleID: String
            ) {
                self.issuer = .init(value: issuer)
                self.issuedAt = .init(value: issuedAt)
                expiration = .init(value: issuedAt.addingTimeInterval(600))
                audience = "appstoreconnect-v1"
                nonce = UUID().uuidString
                self.bundleID = bundleID
            }
            
            func signed(keyID kid: JWKIdentifier, key: ECDSAKey) throws -> String {
                let signers = JWTSigners()
                signers.use(.es256(key: key), kid: kid)
                return try signers.sign(self, typ: "JWT", kid: kid)
            }
            
            func verify(using signer: JWTSigner) throws {
                try audience.verifyIntendedAudience(includes: "appstoreconnect-v1")
                try expiration.verifyNotExpired()
            }
        }
    }

}

fileprivate extension URL {
    
    static func appStoreServer(endpoint: Application.AppStore.Client.Endpoint,
                               environment: Application.AppStore.Environment,
                               originalTransactionID: String
    ) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = environment.host
        switch endpoint {
        case .transactionHistory(let revision):
            urlComponents.path = "/inApps/v1/history/\(originalTransactionID)"
            if let revision = revision {
                urlComponents.queryItems = [.init(name: "revision", value: revision)]
            }
        case .subscriptionStatuses:
            urlComponents.path = "/inApps/v1/subscriptions/\(originalTransactionID)"
        }
        return urlComponents.url!
    }
}

fileprivate extension HTTPHeaders {
    
    static func make(signedToken: String) -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "Bearer \(signedToken)")
        headers.add(name: .userAgent, value: "ReservePayServer")
        return headers
    }
}
