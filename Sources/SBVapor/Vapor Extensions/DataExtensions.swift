import Foundation

extension Data {
    
    func decode<T: Decodable>(
        as type: T.Type,
        using decoder: JSONDecoder = .init()
    ) -> Result<T, DecodingError> {
        do {
            return .success(try decoder.decode(type, from: self))
        } catch {
            guard let error = error as? DecodingError else {
                fatalError("")
            }
            return .failure(error)
        }
    }
}
