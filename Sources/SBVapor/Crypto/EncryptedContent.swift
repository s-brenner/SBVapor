import Vapor

public struct EncryptedContent: Content {
    
    public let id: String
    
    /// Encrypted data that has been Base-64 encoded.
    public let value: String
    
    fileprivate init(id: String, value: Encryption.Encrypted) {
        self.id = id
        self.value = value.base64EncodedString
    }
    
    @available(macOS, deprecated: 15, message: "This is initializer is for testing purposes only")
    public init(id: String, value: String) {
        self.id = id
        self.value = value
    }
}

public extension EncryptedContent {
    
    func decrypted<T: Content>(
        as type: T.Type,
        with key: SymmetricKey,
        decoder: JSONDecoder = .init()
    ) throws -> T {
        let data = try Encryption.decrypt(self.value, with: key)
        return try decoder.decode(T.self, from: data)
    }
}

public extension Content {
    
    func encrypted(
        with id: String,
        key: SymmetricKey,
        encoder: JSONEncoder = .init()
    ) throws -> EncryptedContent {
        let data = try encoder.encode(self)
        let encrypted = try Encryption.encrypt(data, with: key)
        return .init(id: id, value: encrypted)
    }
}

public extension ContentContainer {
    
    func decrypt<T: Content>(
        as value: T.Type,
        with key: SymmetricKey,
        decoder: JSONDecoder = .init()
    ) throws -> T {
        try decode(EncryptedContent.self)
            .decrypted(as: T.self, with: key, decoder: decoder)
    }
}
