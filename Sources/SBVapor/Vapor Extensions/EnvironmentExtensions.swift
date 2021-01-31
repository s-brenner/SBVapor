import Vapor

extension Environment {
    
    static func result<E: Error>(
        _ key: String,
        _ transform: (_ key: String) -> E
    ) -> Result<String, E> {
        guard let value = get(key) else {
            return .failure(transform(key))
        }
        return .success(value)
    }
}
