import Vapor

extension Application {
    
    public struct Crypto {
        
        typealias KeyAgreement = P256.KeyAgreement
        
//        public enum Error: LocalizedError {
////            case noEnvironmentValue(_ key: String)
//            case notBase64Encoded(_ key: String, _ value: String)
//            case privateKeyError(_ underlyingError: Swift.Error)
//
//            public var errorDescription: String? {
//                var string = "CryptoError"
//                if let reason = failureReason {
//                    string += "\n\t\(reason)"
//                }
//                if let recovery = recoverySuggestion {
//                    string += "\n\t\(recovery)"
//                }
//                return string
//            }
//
//            public var failureReason: String? {
//                switch self {
////                case .noEnvironmentValue(let key):
////                    return "The environment key \(key) is not defined"
//                case .notBase64Encoded(let key, let value):
//                    return "The value for \(key) (\(value)) is not Base-64 encoded"
//                case .privateKeyError(let error):
//                    return error.localizedDescription
//                }
//            }
//
//            public var recoverySuggestion: String? {
//                "Try \(SymmetricKey.base64Encoded())"
//            }
//        }
        
        public func initialize() {
            do {
                let symmetricKeyClient = try Environment.symmetricKey(forKey: "CRYPTO_SYMMETRIC_KEY_CLIENT")
                let symmetricKeyDatabase = try Environment.symmetricKey(forKey: "CRYPTO_SYMMETRIC_KEY_DATABASE")
                let privateKey = try Environment.privateKey(forKey: "CRYPTO_PRIVATE_KEY")
                application.storage[Key.self] = Storage(
                    symmetricKeyClient: symmetricKeyClient,
                    symmetricKeyDatabase: symmetricKeyDatabase,
                    privateKey: privateKey
                )
                application.logger.notice("Crypto initialized")
            }
            catch {
                if let environmentError = error as? Environment.Error {
                    switch environmentError {
                    case .noEnvironmentValue(let key), .notBase64Encoded(let key, _):
                        fatalError("The value for \(key) is either missing or not properly encoded. Try \(SymmetricKey.base64Encoded())")
                    }
                }
            }
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
            case asymmetric(_ salt: Salt, _ devicePublicKey: Data)
        }
        
        public func symmetricKey(_ strategy: EncryptionStrategy) throws -> SymmetricKey {
            switch strategy {
            case .symmetricClient:
                return storage.symmetricKeyClient
            case .symmetricDatabase:
                return storage.symmetricKeyDatabase
            case .asymmetric(let salt, let devicePublicKey):
                let devicePublicKey = try KeyAgreement.PublicKey(x963Representation: devicePublicKey)
                return try storage.privateKey
                    .sharedSecretFromKeyAgreement(with: devicePublicKey)
                    .hkdfDerivedSymmetricKey(
                        using: SHA256.self,
                        salt: salt.data,
                        sharedInfo: Data(),
                        outputByteCount: 32
                    )
            }
        }
        
        /// An ANSI x9.63 representation of the public key.
        public var publicKey: Data { storage.privateKey.publicKey.x963Representation }
        
        public func encrypt<Item>(_ item: Item, strategy: EncryptionStrategy) throws -> String
        where Item: Encodable {
            let data = try JSONEncoder().encode(item)
            return try Encryption.encrypt(data, with: symmetricKey(strategy)).get().base64EncodedString
        }
        
        public func decrypt<Item>(
            _ base64Encoded: String,
            into item: Item.Type = Item.self,
            strategy: EncryptionStrategy
        ) throws -> Item
        where Item: Decodable {
            let data = try Encryption.decrypt(base64Encoded, with: symmetricKey(strategy)).get()
            return try JSONDecoder().decode(item, from: data)
        }
    }
    
    public var crypto: Crypto { .init(application: self) }
}

private extension Application.Crypto {
    
    final class Storage {
        
        let symmetricKeyClient: SymmetricKey
        
        let symmetricKeyDatabase: SymmetricKey
        
        let privateKey: KeyAgreement.PrivateKey
        
        init(
            symmetricKeyClient: SymmetricKey,
            symmetricKeyDatabase: SymmetricKey,
            privateKey: KeyAgreement.PrivateKey
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
