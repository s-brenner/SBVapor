//import Vapor
//
//public extension EventLoopFuture {
//
//    func throwingFlatMap<NewValue>(
//        _ transform: @escaping (Value) throws -> EventLoopFuture<NewValue>
//    ) -> EventLoopFuture<NewValue> {
//        flatMap { [unowned self] value in
//            do {
//                return try transform(value)
//            } catch {
//                return self.eventLoop.makeFailedFuture(error)
//            }
//        }
//    }
//}
//
//
//// MARK: - Logging
//
//public extension EventLoopFuture {
//
//    internal func log(
//        level: Logger.Level,
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        logger.log(level: max(level, logger.logLevel), message(), metadata: metadata(), source: source())
//        return self
//    }
//
//    /// Appropriate for messages that contain information normally of use only when debugging a program.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
//    ///   - metadata: One-off metadata to attach to this log message.
//    ///   - source: The source this log messages originates to.
//    ///   - logger: The logger on which to log the message.
//    func logTrace(
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        log(level: .trace, message(), metadata: metadata(), source: source(), on: logger)
//    }
//
//    /// Appropriate for informational messages.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
//    ///   - metadata: One-off metadata to attach to this log message.
//    ///   - source: The source this log messages originates to.
//    ///   - logger: The logger on which to log the message.
//    func logInfo(
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        log(level: .info, message(), metadata: metadata(), source: source(), on: logger)
//    }
//
//    /// Appropriate for conditions that are not error conditions, but that may require special handling.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
//    ///   - metadata: One-off metadata to attach to this log message.
//    ///   - source: The source this log messages originates to.
//    ///   - logger: The logger on which to log the message.
//    func logNotice(
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        log(level: .notice, message(), metadata: metadata(), source: source(), on: logger)
//    }
//
//    /// Appropriate for messages that are not error conditions, but more severe than `.notice`.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
//    ///   - metadata: One-off metadata to attach to this log message.
//    ///   - source: The source this log messages originates to.
//    ///   - logger: The logger on which to log the message.
//    func logWarning(
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        log(level: .warning, message(), metadata: metadata(), source: source(), on: logger)
//    }
//
//    /// Appropriate for error conditions.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
//    ///   - metadata: One-off metadata to attach to this log message.
//    ///   - source: The source this log messages originates to.
//    ///   - logger: The logger on which to log the message.
//    func logError(
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        log(level: .error, message(), metadata: metadata(), source: source(), on: logger)
//    }
//
//    /// Appropriate for critical error conditions that usually require immediate
//    /// attention.
//    ///
//    /// When a `critical` message is logged, the logging backend (`LogHandler`) is free to perform
//    /// more heavy-weight operations to capture system state (such as capturing stack traces) to facilitate
//    /// debugging.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
//    ///   - metadata: One-off metadata to attach to this log message.
//    ///   - source: The source this log messages originates to.
//    ///   - logger: The logger on which to log the message.
//    func logCritical(
//        _ message: @autoclosure () -> Logger.Message,
//        metadata: @autoclosure () -> Logger.Metadata? = nil,
//        source: @autoclosure () -> String? = nil,
//        on logger: Logger
//    ) -> EventLoopFuture<Value> {
//        log(level: .critical, message(), metadata: metadata(), source: source(), on: logger)
//    }
//
//    /// Log an error message to a provided logger when the current `EventLoopFuture<Value>` is in an error state.
//    /// - Author: - Scott Brenner | SBVapor
//    /// - Parameters:
//    ///   - logger: The logger on which to log the message.
//    ///   - message: The message to be logged.
//    ///   - error: The error value of this `EventLoopFuture<Value>`.
//    /// - Returns: A failed `EventLoopFuture<Value>`.
//    func logErrorState(
//        on logger: Logger,
//        _ message: @escaping (_ error: Error) -> Logger.Message
//    ) -> EventLoopFuture<Value> {
//        flatMapError { [eventLoop] error in
//            logger.log(level: max(.error, logger.logLevel), message(error))
//            return eventLoop.future(error: error)
//        }
//    }
//}
