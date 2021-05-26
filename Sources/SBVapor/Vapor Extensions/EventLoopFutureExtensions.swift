import Vapor

public extension EventLoopFuture {
    
    func throwingFlatMap<NewValue>(
        _ transform: @escaping (Value) throws -> EventLoopFuture<NewValue>
    ) -> EventLoopFuture<NewValue> {
        flatMap { [unowned self] value in
            do {
                return try transform(value)
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }
    
    func notice(_ message: Logger.Message, on logger: Logger) -> EventLoopFuture<Value> {
        logger.notice(message)
        return self
    }
}
