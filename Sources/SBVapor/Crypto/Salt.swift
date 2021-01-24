import Foundation

public struct Salt {
    
    public let data: Data
    
    public init(count: Int = 32) {
        data = Data([UInt8].random(count: count))
    }
    
    public init(_ data: Data) {
        self.data = data
    }
}
