import Vapor

public protocol EncryptedModel: Model {
    
    func encrypt<T: Encodable>(
        _ value: T,
        to keyPath: ReferenceWritableKeyPath<Self, String?>,
        with crypto: Application.Crypto
    ) throws
    
    func decrypt<T: Decodable>(
        _ keyPath: ReferenceWritableKeyPath<Self, String?>,
        as type: T.Type,
        with crypto: Application.Crypto
    ) throws -> T?
}

public extension EncryptedModel {
    
    func encrypt<T: Encodable>(
        _ value: T,
        to keyPath: ReferenceWritableKeyPath<Self, String?>,
        with crypto: Application.Crypto
    ) throws {
        self[keyPath: keyPath] = try crypto.encrypt(value, strategy: .symmetricDatabase)
    }
    
    func decrypt<T: Decodable>(
        _ keyPath: ReferenceWritableKeyPath<Self, String?>,
        as type: T.Type = T.self,
        with crypto: Application.Crypto
    ) throws -> T? {
        guard let encrypted = self[keyPath: keyPath] else { return nil }
        return try crypto.decrypt(encrypted, into: type, strategy: .symmetricDatabase)
    }
}
