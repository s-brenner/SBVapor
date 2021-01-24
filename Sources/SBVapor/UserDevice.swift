import Vapor

public struct UserDevice: Content, Validatable {
    
    enum CodingKeys: String, CodingKey {
        case applicationVersion = "application_version",
             name,
             systemName = "system_name",
             systemVersion = "system_version",
             model,
             identifierForVendor = "identifier_for_vendor",
             publicKey = "public_key"
    }
    
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
    
    /// The user's public key x963 representation data Base-64 encoded.
    public let publicKey: String
    
    public static func validations(_ validations: inout Validations) {
        validations.add(CodingKeys.applicationVersion, as: String.self, is: !.empty)
        validations.add(CodingKeys.name, as: String.self, is: !.empty)
        validations.add(CodingKeys.systemName, as: String.self, is: !.empty)
        validations.add(CodingKeys.systemVersion, as: String.self, is: !.empty)
        validations.add(CodingKeys.model, as: String.self, is: !.empty)
        validations.add(CodingKeys.identifierForVendor, as: String.self, is: !.empty)
        validations.add(CodingKeys.publicKey, as: String.self, is: !.empty)
    }
}
