
protocol PrettyPrintable: Encodable {
    
    var prettyPrinted: String { get }
}

extension PrettyPrintable {
    
    var prettyPrinted: String {
        let data = try! JSONEncoder().encode(self)
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        return String(data: jsonData, encoding: .utf8)!
    }
}
