import Foundation

public extension Application.AppStore {
    
    @frozen enum Environment: String, CustomStringConvertible, CustomDebugStringConvertible {
        case production = "Production"
        case sandbox = "Sandbox"
        
        var host: String {
            switch self {
            case .production: return "api.storekit.itunes.apple.com"
            case .sandbox: return "api.storekit-sandbox.itunes.apple.com"
            }
        }
        
        public var description: String { rawValue }
        
        public var debugDescription: String { rawValue }
    }
}
