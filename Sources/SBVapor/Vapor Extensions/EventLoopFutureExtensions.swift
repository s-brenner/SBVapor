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
    
    func log(
        level: Logger.Level,
        _ message: Logger.Message,
        metadata: Logger.Metadata? = nil,
        source: String? = nil,
        on logger: Logger
    ) -> EventLoopFuture<Value> {
        logger.log(level: level, message, metadata: metadata, source: source)
        return self
    }
}
