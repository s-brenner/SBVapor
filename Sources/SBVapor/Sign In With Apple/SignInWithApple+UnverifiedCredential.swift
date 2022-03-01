import Vapor

public extension Application.SignInWithApple {
    
    struct UnverifiedCredential: Content, Validatable {
        
        enum CodingKeys: String, CodingKey {
            case userIdentifier = "user_identifier"
            case authorizationCode = "authorization_code"
            case identityToken = "identity_token"
            case email
            case familyName = "family_name"
            case givenName = "given_name"
            case realUserStatus = "real_user_status"
        }
        
        public let userIdentifier: String
        
        public let authorizationCode: String
        
        public let identityToken: String
        
        public let email: String?
        
        public let familyName: String?
        
        public let givenName: String?
        
        public let realUserStatus: Int
        
        init(
            userIdentifier: String,
            authorizationCode: String,
            identityToken: String,
            email: String? = nil,
            familyName: String? = nil,
            givenName: String? = nil,
            realUserStatus: Int = 0
        ) {
            self.userIdentifier = userIdentifier
            self.authorizationCode = authorizationCode
            self.identityToken = identityToken
            self.email = email
            self.familyName = familyName
            self.givenName = givenName
            self.realUserStatus = realUserStatus
        }
        
        public static func validations(_ validations: inout Validations) {
            validations.add(CodingKeys.userIdentifier, as: String.self, is: !.empty)
            validations.add(CodingKeys.authorizationCode, as: String.self, is: !.empty)
            validations.add(CodingKeys.identityToken, as: String.self, is: !.empty)
        }
    }
}
