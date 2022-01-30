//import Vapor
//
//public extension AppStoreServerNotifications {
//
//    struct UnifiedReceipt: Content {
//
//        public let environment: Environment?
//        public typealias Environment = Application.AppStore.Environment
//
//        public let latestReceipt: Data?
//
//        public let latestReceiptInfo: [LatestReceiptInfo]?
//        public typealias LatestReceiptInfo = Application.AppStore.LatestReceiptInfo
//
//        public let pendingRenewalInfo: [PendingRenewalInfo]?
//        public typealias PendingRenewalInfo = Application.AppStore.PendingRenewalInfo
//
//        public let status: Status?
//
//        init?(_ unifiedReceipt: InternalUnifiedReceipt?) {
//            guard let unifiedReceipt = unifiedReceipt else { return nil }
//            environment = Environment(rawValue: unifiedReceipt.environment ?? "")
//            latestReceipt = unifiedReceipt.latestReceipt
//            latestReceiptInfo = unifiedReceipt.latestReceiptInfo?.compactMap { LatestReceiptInfo($0) }
//            pendingRenewalInfo = unifiedReceipt.pendingRenewalInfo?.compactMap { PendingRenewalInfo($0) }
//            status = Status(rawValue: unifiedReceipt.status ?? -1)
//        }
//
//        public enum Status: Int, Codable {
//            case valid = 0
//        }
//    }
//}
//
//extension AppStoreServerNotifications {
//
//    struct InternalUnifiedReceipt: Content {
//
//        enum CodingKeys: String, CodingKey {
//            case environment
//            case latestReceipt = "latest_receipt"
//            case latestReceiptInfo = "latest_receipt_info"
//            case pendingRenewalInfo = "pending_renewal_info"
//            case status
//        }
//
//        let environment: String?
//        let latestReceipt: Data?
//        let latestReceiptInfo: [Application.AppStore.InternalLatestReceiptInfo]?
//        let pendingRenewalInfo: [Application.AppStore.InternalPendingRenewalInfo]?
//        let status: Int?
//    }
//}
