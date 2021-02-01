import Vapor

public struct EncryptedContent: Content {
    
    /// Encrypted data that has been Base-64 encoded.
    public let encrypted: String
    
    fileprivate init(encrypted: Encryption.Encrypted) {
        self.encrypted = encrypted.base64EncodedString
    }
}

public extension EncryptedContent {
    
    func decrypted<T: Content>(
        as value: T.Type,
        with key: SymmetricKey,
        decoder: JSONDecoder = .init()
    ) throws -> T {
        let data = try Encryption.decrypt(encrypted, with: key).get()
        return try decoder.decode(T.self, from: data)
    }
}

public extension Content {
    
    func encrypted(
        with key: SymmetricKey,
        encoder: JSONEncoder = .init()
    ) throws -> EncryptedContent {
        let data = try encoder.encode(self)
        let encrypted = try Encryption.encrypt(data, with: key).get()
        return .init(encrypted: encrypted)
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
        with key: SymmetricKey,
        encoder: JSONEncoder = .init()
    ) -> EventLoopFuture<EncryptedContent> {
        flatMapThrowing { try $0.encrypted(with: key, encoder: encoder) }
    }
}
