import Vapor

extension Environment {
    
    static func value(forKey key: String) throws -> String {
        guard let value = get(key) else {
            throw Error.noEnvironmentValue(key)
        }
        return value
    }
    
    static func data(forKey key: String) throws -> Data {
        let string = try value(forKey: key)
        guard let data = Data(base64Encoded: string) else {
            throw Error.notBase64Encoded(key, string)
        }
        return data
    }
    
    public enum Error: LocalizedError {
        case noEnvironmentValue(_ key: String)
        case notBase64Encoded(_ key: String, _ value: String)
        
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
            case .noEnvironmentValue(let key):
                return "The environment key \(key) is not defined"
            case .notBase64Encoded(let key, let value):
                return "The value for \(key) (\(value)) is not Base-64 encoded"
            }
        }
        
        public var recoverySuggestion: String? { nil }
    }
}
