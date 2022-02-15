import Vapor

public enum Encryption {
    
    enum Error: AbortError {
        case sealFailure(Swift.Error)
        case encodingError(String, String.Encoding)
        case notBase64Encoded(String)
        case couldNotMakeSealedBox(Swift.Error)
        case couldNotOpenSealedBox(Swift.Error)
        
        public var reason: String {
            switch self {
            case .sealFailure(let error):
                return error.localizedDescription
            case .encodingError(let string, let encoding):
                return "\(string) could not be encoded as \(encoding.description)."
            case .notBase64Encoded(let string):
                return "\(string) is not Base64 encoded"
            case .couldNotMakeSealedBox(let error):
                return error.localizedDescription
            case .couldNotOpenSealedBox(let error):
                return error.localizedDescription
            }
        }
        
        public var status: HTTPResponseStatus { .internalServerError }
    }
    
    struct Encrypted {
        
        public let data: Data
        
        public var base64EncodedString: String {
            data.base64EncodedString()
        }
        
        fileprivate init(data: Data) {
            self.data = data
        }
    }
    
    static func encrypt(_ data: Data, with key: SymmetricKey) throws -> Encrypted {
        do {
            return Encrypted(data: try ChaChaPoly.seal(data, using: key).combined)
        }
        catch {
            throw Error.sealFailure(error)
        }
    }
    
    static func encrypt(_ string: String, with key: SymmetricKey, encoding: String.Encoding = .utf8) throws -> Encrypted {
        guard let data = string.data(using: encoding) else {
            throw Error.encodingError(string, encoding)
        }
        return try encrypt(data, with: key)
    }
    
    static func decrypt(_ string: String, with key: SymmetricKey) throws -> Data {
        guard let combined = Data(base64Encoded: string) else {
            throw Error.notBase64Encoded(string)
        }
        let sealedBox = try sealedBox(combined: combined)
        return try open(sealedBox, using: key)
    }
    
    static func decryptToString(_ string: String, with key: SymmetricKey, encoding: String.Encoding = .utf8) -> String {
        do {
            let data = try decrypt(string, with: key)
            return String(data: data, encoding: encoding) ?? ""
        }
        catch {
            return ""
        }
    }
}

private extension Encryption {
    
    static func sealedBox(combined: Data) throws -> ChaChaPoly.SealedBox {
        do { return try ChaChaPoly.SealedBox(combined: combined) }
        catch { throw Error.couldNotMakeSealedBox(error) }
    }
    
    static func open(_ sealedBox: ChaChaPoly.SealedBox, using key: SymmetricKey) throws -> Data {
        do { return try ChaChaPoly.open(sealedBox, using: key) }
        catch { throw Error.couldNotOpenSealedBox(error) }
    }
}
