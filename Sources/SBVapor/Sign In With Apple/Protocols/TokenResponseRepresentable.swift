import Foundation

protocol TokenResponseRepresentable {
    
    /// (Reserved for future use)
    /// A token used to access allowed data.
    /// Currently, no data set has been defined for access.
    var accessToken: String { get }
    
    /// The amount of time, in seconds, before the access token expires.
    var expiresIn: Int { get }
    
    /// The type of access token. It will always be `bearer`.
    var tokenType: String { get }
}
