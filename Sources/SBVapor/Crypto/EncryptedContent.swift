import Vapor

public struct EncryptedContent: Content {
    
    public let id: String
    
    /// Encrypted data that has been Base-64 encoded.
    public let value: String
    
    fileprivate init(id: String, value: Encryption.Encrypted) {
        self.id = id
        self.value = value.base64EncodedString
    }
    
    public init(id: String, value: String) {
        #warning("This initializer is for testing purposes only")
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
        let data = try Encryption.decrypt(self.value, with: key).get()
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
        let encrypted = try Encryption.encrypt(data, with: key).get()
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

public extension EventLoopFuture where Value: Content {
    
    func encrypted(
        with id: String,
        key: SymmetricKey,
        encoder: JSONEncoder = .init()
    ) -> EventLoopFuture<EncryptedContent> {
        flatMapThrowing { try $0.encrypted(with: id, key: key, encoder: encoder) }
    }
}
