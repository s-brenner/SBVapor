import JWT
import Vapor

extension Application {
    
    public struct AppStore {
        
        public func initialize() throws {
            let issuerId = try Vapor.Environment.value(forKey: "APPSTORE_ISSUERID")
            let bundleId = try Vapor.Environment.value(forKey: "APPSTORE_BUNDLEID")
            let privateKeyId = try Vapor.Environment.value(forKey: "APPSTORE_SERVER_PRIVATEKEYID")
            let pem = try Vapor.Environment.value(forKey: "APPSTORE_SERVER_PRIVATEKEY")
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
                guard let error = error as? JWTError else { throw error }
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
            do { try initialize() }
            catch { fatalError(error.localizedDescription) }
        }
        return application.storage[Key.self]!
    }
}


// MARK: - Error

public extension Application.AppStore {
    
    enum Error: LocalizedError {
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
            case .privateKeyInvalid(let error):
                return error.reason
            }
        }
        
        public var recoverySuggestion: String? { nil }
    }
}
