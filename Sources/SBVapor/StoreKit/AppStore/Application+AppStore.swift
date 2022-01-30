import JWT
import Vapor

extension Application {
    
    public struct AppStore {
        
        public func initialize() throws {
            let issuerId = Vapor.Environment
                .result("APPSTORE_ISSUERID") { Error.noEnvironmentValue($0) }
                .fatalError(\.errorDescription!)
            let bundleId = Vapor.Environment
                .result("APPSTORE_BUNDLEID") { Error.noEnvironmentValue($0) }
                .fatalError(\.errorDescription!)
            let privateKeyId = Vapor.Environment
                .result("APPSTORE_SERVER_PRIVATEKEYID") { Error.noEnvironmentValue($0) }
                .fatalError(\.errorDescription!)
            let pem = Vapor.Environment
                .result("APPSTORE_SERVER_PRIVATEKEY") { Error.noEnvironmentValue($0) }
                .fatalError(\.errorDescription!)
            do {
                let privateKey = try ECDSAKey.private(pem: pem)
                application.storage[Key.self] = Storage(
                    issuerId: issuerId,
                    bundleId: bundleId,
                    privateKeyId: privateKeyId,
                    privateKey: privateKey
                )
                application.logger.notice("AppStore initialized")
            }
            catch {
                guard let error = error as? JWTError else { return }
                throw Error.privateKeyInvalid(error)
            }
        }
        
        fileprivate let application: Application
        
        public var client: Client {
            Client(
                httpClient: application.http.client.shared,
                issuerId: storage.issuerId,
                bundleId: storage.bundleId,
                privateKeyId: .init(string: storage.privateKeyId),
                privateKey: storage.privateKey
            )
        }
    }
    
    public var appStore: AppStore { .init(application: self) }
}

private extension Application.AppStore {
    
    final class Storage {
        
        let issuerId: String
        
        let bundleId: String
        
        let privateKeyId: String
        
        let privateKey: ECDSAKey
        
        init(issuerId: String, bundleId: String, privateKeyId: String, privateKey: ECDSAKey) {
            self.issuerId = issuerId
            self.bundleId = bundleId
            self.privateKeyId = privateKeyId
            self.privateKey = privateKey
        }
    }
    
    struct Key: StorageKey {
        typealias Value = Storage
    }
    
    var storage: Storage {
        if application.storage[Key.self] == nil {
            try! initialize()
        }
        return application.storage[Key.self]!
    }
}

public extension Application.AppStore {
    
    enum Error: LocalizedError {
        case noEnvironmentValue(_ key: String)
        case privateKeyInvalid(_ error: JWTError)
        
        public var errorDescription: String? {
            var string = "AppStoreError"
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
            case .privateKeyInvalid(let error):
                return error.reason
            }
        }
        
        public var recoverySuggestion: String? { nil }
    }
}
