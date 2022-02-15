import Vapor

extension SymmetricKey {
    
    /// A Base-64 encoded string representation of a new symmetric key
    /// - Warning: This method is not for production use.
    /// It is only meant to generate a value to save in the environment
    static func base64Encoded() -> String {
        Application.Crypto.KeyAgreement.PrivateKey().rawRepresentation.base64EncodedString()
    }
}
