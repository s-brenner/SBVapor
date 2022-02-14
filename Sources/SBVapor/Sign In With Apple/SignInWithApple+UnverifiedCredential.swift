import Vapor

public extension Application.SignInWithApple {
    
    struct UnverifiedCredential: Content, Validatable {
        
        enum CodingKeys: String, CodingKey {
            case userIdentifier = "user_identifier"
            case authorizationCode = "authorization_code"
            case identityToken = "identity_token"
        }
        
        public let userIdentifier: String
        
        public let authorizationCode: String
        
        public let identityToken: String
        
        public init(userIdentifier: String, authorizationCode: String, identityToken: String) {
            self.userIdentifier = userIdentifier
            self.authorizationCode = authorizationCode
            self.identityToken = identityToken
        }
        
        public static func validations(_ validations: inout Validations) {
            validations.add(CodingKeys.userIdentifier, as: String.self, is: !.empty)
            validations.add(CodingKeys.authorizationCode, as: String.self, is: !.empty)
            validations.add(CodingKeys.identityToken, as: String.self, is: !.empty)
        }
    }
}
