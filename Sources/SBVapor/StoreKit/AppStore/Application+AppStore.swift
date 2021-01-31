import Vapor

extension Application {
    
    public struct AppStore {
        
        public func initialize() {
            let sharedSecret = Vapor.Environment
                .result("APPSTORE_SHARED_SECRET") { Error.noEnvironmentValue($0) }
                .fatalError { $0.errorDescription! }
            application.storage[Key.self] = .init(sharedSecret: sharedSecret)
            application.logger.notice("AppStore initialized")
        }
        
        fileprivate let application: Application
        
        public var client: Client {
            Client(
                httpClient: application.http.client.shared,
                password: storage.sharedSecret
            )
        }
    }
    
    public var appStore: AppStore { .init(application: self) }
}

private extension Application.AppStore {
    
    final class Storage {
        
        let sharedSecret: String
        
        init(sharedSecret: String) {
            self.sharedSecret = sharedSecret
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

public extension Application.AppStore {
    
    enum Error: LocalizedError {
        case noEnvironmentValue(_ key: String)
        
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
            }
        }
        
        public var recoverySuggestion: String? { nil }
    }
}
