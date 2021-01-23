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
        
        public var status: HTTPResponseStatus { .badRequest }
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
    
    static func encrypt(_ data: Data, with key: SymmetricKey) -> Result<Encrypted, Error> {
        Result { try ChaChaPoly.seal(data, using: key).combined }
            .map { .init(data: $0) }
            .mapError { .sealFailure($0) }
    }
    
    static func encrypt(
        _ string: String,
        with key: SymmetricKey,
        encoding: String.Encoding = .utf8
    ) -> Result<Encrypted, Error> {
        guard let data = string.data(using: encoding) else {
            return .failure(.encodingError(string, encoding))
        }
        return encrypt(data, with: key)
    }
    
    static func decrypt(
        _ string: String,
        with key: SymmetricKey
    ) -> Result<Data, Error> {
        guard let combined = Data(base64Encoded: string) else {
            return .failure(.notBase64Encoded(string))
        }
        return sealedBox(combined: combined)
            .flatMap { open($0, using: key) }
    }
    
    static func decryptToString(
        _ string: String,
        with key: SymmetricKey,
        encoding: String.Encoding = .utf8
    ) -> String {
        decrypt(string, with: key)
            .map { String(data: $0, encoding: encoding) }
            .replaceNil(with: "")
            .replaceError(with: "")
    }
}

private extension Encryption {
    
    static func sealedBox(combined: Data) -> Result<ChaChaPoly.SealedBox, Error> {
        Result { try ChaChaPoly.SealedBox(combined: combined) }
            .mapError { .couldNotMakeSealedBox($0) }
    }
    
    static func open(
        _ sealedBox: ChaChaPoly.SealedBox,
        using key: SymmetricKey
    ) -> Result<Data, Error> {
        Result { try ChaChaPoly.open(sealedBox, using: key) }
            .mapError { .couldNotOpenSealedBox($0) }
    }
}
