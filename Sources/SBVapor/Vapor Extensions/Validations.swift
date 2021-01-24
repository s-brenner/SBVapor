import Vapor

public extension Validations {
    
    mutating func add<Key, T>(
        _ key: Key,
        as type: T.Type,
        is validator: Validator<T> = .valid,
        required: Bool = true)
        where Key: CodingKey, Key: RawRepresentable, Key.RawValue == String, T: Decodable {
            add(.init(stringLiteral: key.rawValue), as: T.self, is: validator, required: required)
    }
}
