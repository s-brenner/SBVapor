import Vapor

public extension Application.AppStore {
    
    enum Environment: String, Codable, AppStoreEnvironmentRepresentable {
        case sandbox = "Sandbox"
        case production = "Production"
        
        var environment: Environment { self }
    }
}
