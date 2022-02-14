import Vapor

extension Environment {
    
    static func value(forKey key: String) throws -> String {
        guard let value = get(key) else {
            throw Error.noEnvironmentValue(key)
        }
        return value
    }
    
    public enum Error: LocalizedError {
        case noEnvironmentValue(_ key: String)
        
        public var errorDescription: String? {
            var string = "Vapor Environment Error"
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
            case .noEnvironmentValue(let key): return "The environment key \(key) is not defined"
            }
        }
        
        public var recoverySuggestion: String? { nil }
    }
}
