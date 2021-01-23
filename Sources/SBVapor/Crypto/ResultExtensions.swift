import Foundation

public extension Result {
    
    func replaceError(with replacement: Success) -> Success {
        replaceError { _ in replacement }
    }
    
    func replaceError(_ transform: (Failure) -> Success) -> Success {
        switch self {
        case .success(let success): return success
        case .failure(let error): return transform(error)
        }
    }
    
    func fatalError(_ transform: (Failure) -> String) -> Success {
        switch self {
        case .success(let success): return success
        case .failure(let error): Swift.fatalError(transform(error))
        }
    }
    
    func replaceNil<NewSuccess>(with replacement: NewSuccess) -> Result<NewSuccess, Failure> {
        replaceNil { _ in replacement }
    }
    
    func replaceNil<NewSuccess>(
        _ transform: (Success?) -> NewSuccess
    ) -> Result<NewSuccess, Failure> {
        map(transform)
    }
}
