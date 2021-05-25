import Fluent

public extension FieldKey {
    
    static func prefix<Key>(_ prefix: FieldKey, _ key: Key) -> FieldKey
    where Key: RawRepresentable, Key.RawValue == String {
        .prefix(prefix, .init(stringLiteral: key.rawValue))
    }
}
