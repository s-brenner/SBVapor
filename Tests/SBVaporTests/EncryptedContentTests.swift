import XCTest
@testable import SBVapor

final class EncryptedContentTests: XCTestCase {
    
    func testEncryptionAndDecryption() {
        let mockID = "mock"
        let content = TestContent(date: .init())
        let key = SymmetricKey(size: .bits256)
        do {
            let encrypted = try content.encrypted(with: mockID, key: key)
            let decrypted = try encrypted.decrypted(as: TestContent.self, with: key)
            XCTAssertEqual(encrypted.id, mockID)
            XCTAssertEqual(content.date, decrypted.date)
            let wrongKey = SymmetricKey(size: .bits256)
            XCTAssertThrowsError(try encrypted.decrypted(as: TestContent.self, with: wrongKey))
            XCTAssertThrowsError(try encrypted.decrypted(as: OtherTestContent.self, with: key))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

fileprivate struct TestContent: Content {
    let date: Date
}

fileprivate struct OtherTestContent: Content {
    let name: String
}
