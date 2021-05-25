import Vapor

public enum AppStoreServerNotifications {
    
    public struct ResponseBody: Content, ExpirationIntentRepresentable {
        
        /**
         An identifier that App Store Connect generates and the App Store uses to uniquely identify the auto-renewable subscription that the user’s subscription renews. Treat this value as a 64-bit integer.
         */
        public let autoRenewAdamID: String?
        
        /// The product identifier of the auto-renewable subscription that the user’s subscription renews.
        public let autoRenewProductID: String?
        
        /**
         The current renewal status for an auto-renewable subscription product. Note that these values are different from those of the auto_renew_status in the receipt.
         */
        public let autoRenewStatus: Bool?
        
        /// The time at which the user turned on or off the renewal status for an auto-renewable subscription.
        public let autoRenewStatusChangeDate: Date?
        
        /// The environment for which App Store generated the receipt.
        public let environment: Environment?
        
        public let expirationIntent: ExpirationIntent?
        public typealias ExpirationIntent = Application.AppStore.ExpirationIntent
        
        /// The subscription event that triggered the notification.
        public let notificationType: NotificationType
        
        /// The same value as the shared secret you submit in the password field of the requestBody when validating receipts.
        public let password: String
        
        /// An object that contains information about the most-recent, in-app purchase transactions for the app.
        public let unifiedReceipt: UnifiedReceipt?
        
        /// A string that contains the app bundle ID.
        public let bundleID: String?
        
        /// A string that contains the app bundle version.
        public let bundleVersion: String?
        
        init(_ body: InternalResponseBody) {
            autoRenewAdamID = body.autoRenewAdamID
            autoRenewProductID = body.autoRenewProductID
            autoRenewStatus = body.autoRenewStatus?.bool
            autoRenewStatusChangeDate = Date(milliseconds: body.autoRenewStatusChangeDateMilliseconds)
            environment = Environment(rawValue: body.environment ?? "")
            expirationIntent = ExpirationIntent(rawValue: "\(body.expirationIntent ?? -1)")
            notificationType = NotificationType(rawValue: body.notificationType)!
            password = body.password
            unifiedReceipt = UnifiedReceipt(body.unifiedReceipt)
            bundleID = body.bundleID
            bundleVersion = body.bundleVersion
        }
        
        public enum Environment: String, Codable, AppStoreEnvironmentRepresentable {
            case production = "PROD"
            case sandbox = "Sandbox"
            
            public var environment: AppStoreReceipts.ResponseBody.Environment {
                switch self {
                case .production: return .production
                case .sandbox: return .sandbox
                }
            }
        }
    }
}

extension AppStoreServerNotifications {
    
    struct InternalResponseBody: Content {
        
        enum CodingKeys: String, CodingKey {
            case autoRenewAdamID = "auto_renew_adam_id"
            case autoRenewProductID = "auto_renew_product_id"
            case autoRenewStatus = "auto_renew_status"
            case autoRenewStatusChangeDateMilliseconds = "auto_renew_status_change_date_ms"
            case environment = "environment"
            case expirationIntent = "expiration_intent"
            case notificationType = "notification_type"
            case password
            case unifiedReceipt = "unified_receipt"
            case bundleID = "bid"
            case bundleVersion = "bvrs"
        }
        
        let autoRenewAdamID: String?
        let autoRenewProductID: String?
        let autoRenewStatus: String?
        let autoRenewStatusChangeDateMilliseconds: String?
        let environment: String?
        let expirationIntent: Int?
        let notificationType: String
        let password: String
        let unifiedReceipt: InternalUnifiedReceipt?
        let bundleID: String?
        let bundleVersion: String?
    }
}
