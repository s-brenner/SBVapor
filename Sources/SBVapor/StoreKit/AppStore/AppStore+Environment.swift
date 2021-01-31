import Vapor

public extension Application.AppStore {
    
    enum Environment: String, Codable {
        case sandbox = "Sandbox"
        case production = "Production"
    }
}
