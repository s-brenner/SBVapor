import Vapor

extension Application {
    
    public struct Crypto {
        
        public enum Error: LocalizedError {
            case noEnvironmentValue(_ key: String)
            case notBase64Encoded(_ key: String, _ value: String)
            case privateKeyError(_ underlyingError: Swift.Error)
            
            public var errorDescription: String? {
                var string = "CryptoError"
                if let reason = failureReason {
                    string += "\n\t\(reason)"
                }
                if let recovery = recoverySuggestion {
                    string += "\n\t\(recovery)"
                }
                return string
            }
            
            public var failureReason: String? {
                switch self {
                case .noEnvironmentValue(let key):
                    return "The environment key \(key) is not defined"
                case .notBase64Encoded(let key, let value):
                    return "The value for \(key) (\(value)) is not Base-64 encoded"
                case .privateKeyError(let error):
                    return error.localizedDescription
                }
            }
            
            public var recoverySuggestion: String? {
                "Try \(SymmetricKey.base64Encoded())"
            }
        }
        
        public func initialize() {
            let symmetricKeyClient = Environment
                .symmetricKey("SYMMETRIC_KEY_CLIENT")
                .fatalError { $0.errorDescription! }
            let symmetricKeyDatabase = Environment
                .symmetricKey("SYMMETRIC_KEY_DATABASE")
                .fatalError { $0.errorDescription! }
            let privateKey = Environment
                .privateKey("PRIVATE_KEY")
                .fatalError { $0.errorDescription! }
            self.application.storage[Key.self] =
                .init(
                    symmetricKeyClient: symmetricKeyClient,
                    symmetricKeyDatabase: symmetricKeyDatabase,
                    privateKey: privateKey
                )
            application.logger.notice("Crypto initialized")
        }
        
        fileprivate let application: Application
        
        public enum EncryptionStrategy {
            /// Yields a key known to every client and this server.
            /// Use this strategy for the initial communication steps required to establish asymmetric encryption.
            case symmetricClient
            
            /// Yields a key known only to this server.
            /// Use this strategy to encrypt the contents of the database.
            case symmetricDatabase
            
            /// Yields a key unique to a particular client and this server.
            /// Use this strategy to communicate to a particular user.
            case asymmetric(salt: Data, devicePublicKey: Data)
        }
        
        public func symmetricKey(strategy: EncryptionStrategy) throws -> SymmetricKey {
            switch strategy {
            case .symmetricClient:
                return storage.symmetricKeyClient
            case .symmetricDatabase:
                return storage.symmetricKeyDatabase
            case .asymmetric(let salt, let devicePublicKey):
                let devicePublicKey = try P256.KeyAgreement.PublicKey(x963Representation: devicePublicKey)
                return try storage.privateKey
                    .sharedSecretFromKeyAgreement(with: devicePublicKey)
                    .hkdfDerivedSymmetricKey(
                        using: SHA256.self,
                        salt: salt,
                        sharedInfo: Data(),
                        outputByteCount: 32
                    )
            }
        }
    }
    
    public var crypto: Crypto { .init(application: self) }
}

private extension Application.Crypto {
    
    final class Storage {
        
        let symmetricKeyClient: SymmetricKey
        
        let symmetricKeyDatabase: SymmetricKey
        
        let privateKey: P256.KeyAgreement.PrivateKey
        
        init(
            symmetricKeyClient: SymmetricKey,
            symmetricKeyDatabase: SymmetricKey,
            privateKey: P256.KeyAgreement.PrivateKey
        ) {
            self.symmetricKeyClient = symmetricKeyClient
            self.symmetricKeyDatabase = symmetricKeyDatabase
            self.privateKey = privateKey
        }
    }
    
    struct Key: StorageKey {
        typealias Value = Storage
    }
    
    var storage: Storage {
        if application.storage[Key.self] == nil {
            initialize()
        }
        return application.storage[Key.self]!
    }
}
