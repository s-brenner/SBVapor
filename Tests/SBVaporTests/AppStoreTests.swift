import XCTVapor
@testable import SBVapor
import XCTest

final class AppStoreTests: XCTestCase {
    
//    func testAppStore() async {
//        let app = Application(.testing)
//        defer { app.shutdown() }
//        do {
//            let id = "1000000901570997"
//            try app.appStore.initialize()
//            let response = try await app.appStore.client.getTransactionHistory(environment: .sandbox, originalTransactionID: id)
//            print(response)
//            print(try response.transactions.first)
//            XCTAssertEqual(response.transactions.first?.productType, .autoRenewable)
//            
//            let statusResponse = try await app.appStore.client.getSubscriptionStatuses(environment: .sandbox, originalTransactionID: id)
//            print(statusResponse.data.first?.lastTransactions.first!)
//        }
//        catch {
//            if let e = error as? Application.AppStore.Client.AppStoreError {
//                XCTFail("\(e.status.reasonPhrase):  \(e.reason)")
//            }
//            else if let e = error as? DecodingError {
//                print(e)
//                XCTFail(e.localizedDescription)
//            }
//            else {
//                XCTFail(error.localizedDescription)
//            }
//        }
//    }
    
    func testServerNotification() async {
        do {
            let url = URL(string: "https://atlaswinds.herokuapp.com/appstore/v2")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let signedPayloads = try JSONDecoder().decode([String].self, from: data)
            let decodedPayloads = try signedPayloads.map {
                try JWTSigners().unverified($0, as: Application.AppStore.ResponseBodyV2.DecodedPayload.self)
            }
            print("Decoded \(decodedPayloads.count) server notifications")
        }
        catch {
            if let e = error as? DecodingError {
                print(e)
                XCTFail(e.localizedDescription)
            }
            else {
                print(error)
                XCTFail(error.localizedDescription)
            }
        }
    }
}
