import Foundation
import JWT

extension KeyedDecodingContainer {
    
    func decodeMilliseconds(forKey key: Key) throws -> Date {
        let milliseconds = try decode(Int.self, forKey: key)
        return Date(millisecondsSince1970: milliseconds)
    }
    
    func decodeMillisecondsIfPresent(forKey key: Key) throws -> Date? {
        guard let milliseconds = try decodeIfPresent(Int.self, forKey: key) else { return nil }
        return Date(millisecondsSince1970: milliseconds)
    }
    
    func decode<T>(_ type: T.Type = T.self, forKey key: Key) throws -> T
    where T: RawRepresentable, T.RawValue: Decodable {
        let rawValue = try decode(T.RawValue.self, forKey: key)
        guard let output = T(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "\(rawValue) is not a valid raw value"
            )
        }
        return output
    }
    
    func decodeIfPresent<T>(_ type: T.Type = T.self, forKey key: Key) throws -> T?
    where T: RawRepresentable, T.RawValue: Decodable {
        guard let rawValue = try decodeIfPresent(T.RawValue.self, forKey: key) else { return nil }
        guard let output = T(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "\(rawValue) is not a valid raw value"
            )
        }
        return output
    }
    
    func decode<Payload>(
        _ type: Payload.Type = Payload.self,
        using signers: JWTSigners = .init(),
        forKey key: Key
    ) throws -> Payload
    where Payload: JWTPayload {
        let token = try decode(String.self, forKey: key)
        return try signers.unverified(token, as: Payload.self)
    }
}
