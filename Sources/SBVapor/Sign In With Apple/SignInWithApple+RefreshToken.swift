public extension Application.SignInWithApple {
    
    struct RefreshToken {
        
        public let value: String
        
        public let validationDate: Date?
        
        public init?(value: String, validationDate: Date?) {
            guard !value.isEmpty else { return nil }
            self.value = value
            self.validationDate = validationDate
        }
    }
}
