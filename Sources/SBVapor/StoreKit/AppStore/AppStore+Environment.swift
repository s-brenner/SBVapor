import Foundation

public extension Application.AppStore {
    
    enum Environment: String {
        case production = "Production"
        case sandbox = "Sandbox"
        
        var host: String {
            switch self {
            case .production: return "api.storekit.itunes.apple.com"
            case .sandbox: return "api.storekit-sandbox.itunes.apple.com"
            }
        }
    }
}
