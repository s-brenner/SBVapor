import NIOCore

extension ByteBuffer: CustomDebugStringConvertible {
    
    public var debugDescription: String { readableBytesView.debugDescription }
}

extension ByteBufferView: CustomDebugStringConvertible {
    
    public var debugDescription: String { String(decoding: self, as: UTF8.self) }
}
