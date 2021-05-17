import Vapor

public struct UserDevice: Content {
    
    /// The version of the iOS application installed on the device.
    public let applicationVersion: String
    
    /// The name identifying the device.
    public let name: String
    
    /// The name of the operating system running on the device.
    public let systemName: String
    
    /// The current version of the operating system.
    public let systemVersion: String
    
    /// The model of the device.
    public let model: String
    
    /// An alphanumeric string that uniquely identifies a device to the app’s vendor.
    public let identifierForVendor: String
}
