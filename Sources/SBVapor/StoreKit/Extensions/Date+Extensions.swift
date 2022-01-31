import Foundation

extension Date {
    
    init(millisecondsSince1970 milliseconds: Int) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
