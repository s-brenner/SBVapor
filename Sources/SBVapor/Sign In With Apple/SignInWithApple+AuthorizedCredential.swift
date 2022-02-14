import JWT

public extension Application.SignInWithApple {
    
    struct AuthorizedCredential: Content {
        
        public let identityToken: AppleIdentityToken?
        
        public let accessToken: AccessToken
        
        public let refreshToken: String
        
        public let refreshTokenValidationDate: Date?
        
        init(
            identityToken: AppleIdentityToken,
            tokenResponse: AuthorizationCodeValidation.TokenResponse
        ) {
            self.identityToken = identityToken
            accessToken = AccessToken(tokenResponse, issueDate: Date())
            refreshToken = tokenResponse.refreshToken
            refreshTokenValidationDate = nil
        }
        
        init(
            unvalidatedRefreshToken: RefreshToken,
            tokenResponse: RefreshTokenValidation.TokenResponse
        ) {
            let now = Date()
            identityToken = nil
            accessToken = AccessToken(tokenResponse, issueDate: now)
            refreshToken = unvalidatedRefreshToken.value
            refreshTokenValidationDate = now
        }
    }
}

public extension Application.SignInWithApple.AuthorizedCredential {
    
    struct AccessToken: Content {
        
        public let value: String
        
        public let type: String
        
        public let expirationDate: Date
        
        fileprivate init(_ response: TokenResponseRepresentable, issueDate: Date) {
            value = response.accessToken
            type = response.tokenType
            expirationDate = issueDate.addingTimeInterval(TimeInterval(response.expiresIn))
        }
    }
}
