import Vapor

extension Environment {
    
    typealias PrivateKey = Application.Crypto.KeyAgreement.PrivateKey
    
    /// Creates a key from the given environment key.
    /// - Parameter key: The environment key that corresponds to data stored as a Base-64 encoded string
    static func symmetricKey(forKey key: String) throws -> SymmetricKey {
        let data = try data(forKey: key)
        return SymmetricKey(data: data)
    }
    
    static func privateKey(forKey key: String) throws -> PrivateKey {
        let data = try data(forKey: key)
        return try PrivateKey(rawRepresentation: data)
    }
}
