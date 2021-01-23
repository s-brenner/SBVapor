import Vapor

extension Environment {
    
    typealias PrivateKey = P256.KeyAgreement.PrivateKey
    
    typealias CryptoError = Application.Crypto.Error
    
    /// Creates a key from the given environment key.
    /// - Parameter key: The environment key that corresponds to data stored as a Base-64 encoded string
    static func symmetricKey(_ key: String) -> Result<SymmetricKey, CryptoError> {
        data(key)
            .map { .init(data: $0) }
    }
    
    static func privateKey(_ key: String) -> Result<PrivateKey, CryptoError> {
        data(key)
            .flatMap { data in
                Result { try P256.KeyAgreement.PrivateKey(rawRepresentation: data) }
                    .mapError { .privateKeyError($0) }
            }
    }
}

private extension Environment {
    
    static func data(_ key: String) -> Result<Data, CryptoError> {
        guard let string = get(key) else {
            return .failure(.noEnvironmentValue(key))
        }
        guard let data = Data(base64Encoded: string) else {
            return .failure(.notBase64Encoded(key, string))
        }
        return .success(data)
    }
}
