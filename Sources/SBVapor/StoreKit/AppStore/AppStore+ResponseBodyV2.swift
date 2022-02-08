import JWT
import Vapor

extension Application.AppStore {
    
    /// The response body the App Store sends in a version 2 server notification.
    public struct ResponseBodyV2: Content {
        
        /// A cryptographically signed payload, in JSON Web Signature (JWS) format,
        /// containing the response body for a version 2 notification.
        let signedPayload: String
    }
}

public extension Application.AppStore.ResponseBodyV2 {
    
    /// A decoded payload containing the version 2 notification data.
    struct DecodedPayload: JWTPayload {
        
        /// The in-app purchase event for which the App Store sent this version 2 notification.
        public let notificationType: NotificationType
        
        /// Additional information that identifies the notification event, or an empty string.
        /// The subtype applies only to select version 2 notifications.
        public let subtype: NotificationType.Subtype
        
        /// A unique identifier for the notification.
        /// Use this value to identify a duplicate notification.
        public let notificationUUID: UUID
        
        /// The version number of the notification.
        public let notificationVersion: String?
        
        /// The object that contains the app metadata and signed renewal and transaction information.
        public let data: PayloadData
        
        private enum CodingKeys: String, CodingKey {
            case notificationType
            case subtype
            case notificationUUID
            case notificationVersion
            case data
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            notificationType = try values.decode(forKey: .notificationType)
            subtype = try values.decode(forKey: .subtype)
            notificationUUID = try values.decodeUUID(forKey: .notificationUUID)
            notificationVersion = try values.decodeIfPresent(String.self, forKey: .notificationVersion)
            data = try values.decode(PayloadData.self, forKey: .data)
        }
        
        public func encode(to encoder: Encoder) throws {
            fatalError("Not implemented")
        }
        
        public func verify(using signer: JWTSigner) throws { }
    }
}

public extension Application.AppStore.ResponseBodyV2.DecodedPayload {
    
    struct NotificationType: Equatable, Hashable, RawRepresentable {
        
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let consumptionRequest = Self(rawValue: "CONSUMPTION_REQUEST")
        
        public static let didChangeRenewalPreference = Self(rawValue: "DID_CHANGE_RENEWAL_PREF")
        
        public static let didChangeRenewalStatus = Self(rawValue: "DID_CHANGE_RENEWAL_STATUS")
        
        public static let didFailToRenew = Self(rawValue: "DID_FAIL_TO_RENEW")
        
        public static let didRenew = Self(rawValue: "DID_RENEW")
        
        public static let expired = Self(rawValue: "EXPIRED")
        
        public static let gracePeriodExpired = Self(rawValue: "GRACE_PERIOD_EXPIRED")
        
        public static let offerRedeemed = Self(rawValue: "OFFER_REDEEMED")
        
        public static let priceIncrease = Self(rawValue: "PRICE_INCREASE")
        
        public static let refund = Self(rawValue: "REFUND")
        
        public static let refundDeclined = Self(rawValue: "REFUND_DECLINED")
        
        public static let renewalExtended = Self(rawValue: "RENEWAL_EXTENDED")
        
        public static let revoke = Self(rawValue: "REVOKE")
        
        public static let subscribed = Self(rawValue: "SUBSCRIBED")
    }
    
    /// The app metadata and signed renewal and transaction information.
    struct PayloadData: Decodable {
        
        /// The unique identifier of the app that the notification applies to.
        public let appAppleID: String?
        
        /// The bundle identifier of the app.
        public let bundleID: String
        
        /// The version of the build that identifies an iteration of the bundle.
        public let bundleVersion: String
        
        /// The server environment that the notification applies to, either sandbox or production.
        public let environment: Application.AppStore.Environment
        
        /// Subscription renewal information.
        public let renewalInfo: Application.AppStore.JWSRenewalInfoDecodedPayload?
        
        /// Transaction information.
        public let transactionInfo: Application.AppStore.JWSTransactionDecodedPayload?
        
        private enum CodingKeys: String, CodingKey {
            case appAppleId
            case bundleId
            case bundleVersion
            case environment
            case signedRenewalInfo
            case signedTransactionInfo
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            appAppleID = try values.decodeIfPresent(String.self, forKey: .appAppleId)
            bundleID = try values.decode(String.self, forKey: .bundleId)
            bundleVersion = try values.decode(String.self, forKey: .bundleVersion)
            environment = try values.decode(forKey: .environment)
            renewalInfo = try values.decodeIfPresent(forKey: .signedRenewalInfo)
            transactionInfo = try values.decodeIfPresent(forKey: .signedTransactionInfo)
        }
    }
}

public extension Application.AppStore.ResponseBodyV2.DecodedPayload.NotificationType {
    
    struct Subtype: Equatable, Hashable, RawRepresentable {
        
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        /// Applies to the SUBSCRIBED notificationType.
        /// A notification with this subtype indicates that the user purchased the subscription for the first time.
        public static let initialBuy = Self(rawValue: "INITIAL_BUY")
        
        /// Applies to the SUBSCRIBED notificationType.
        /// A notification with this subtype indicates that the user resubscribed or received access through Family Sharing
        /// to the same subscription or to another subscription within the same subscription group.
        public static let resubscribe = Self(rawValue: "RESUBSCRIBE")
        
        /// Applies to the DID_CHANGE_RENEWAL_PREF notificationType.
        /// A notification with this subtype indicates that the user downgraded their subscription.
        /// Downgrades take effect at the next renewal.
        public static let downgrade = Self(rawValue: "DOWNGRADE")
        
        /// Applies to the DID_CHANGE_RENEWAL_PREF notificationType.
        /// A notification with this subtype indicates that the user upgraded their subscription.
        /// Upgrades take effect immediately.
        public static let upgrade = Self(rawValue: "UPGRADE")
        
        /// Applies to the DID_CHANGE_RENEWAL_STATUS notificationType.
        /// A notification with this subtype indicates that the user enabled subscription auto-renewal.
        public static let autoRenewEnabled = Self(rawValue: "AUTO_RENEW_ENABLED")
        
        /// Applies to the DID_CHANGE_RENEWAL_STATUS notificationType.
        /// A notification with this subtype indicates that the user disabled subscription auto-renewal,
        /// or the App Store disabled subscription auto-renewal after the user requested a refund.
        public static let autoRenewDisabled = Self(rawValue: "AUTO_RENEW_DISABLED")
        
        /// Applies to the EXPIRED notificationType.
        /// A notification with this subtype indicates that the subscription expired after the user disabled subscription auto-renewal.
        public static let voluntary = Self(rawValue: "VOLUNTARY")
        
        /// Applies to the EXPIRED notificationType.
        /// A notification with this subtype indicates that the subscription expired
        /// because the subscription failed to renew before the billing retry period ended.
        public static let billingRetry = Self(rawValue: "BILLING_RETRY")
        
        /// Applies to the EXPIRED notificationType.
        /// A notification with this subtype indicates that the subscription expired
        /// because the user didn’t consent to a price increase.
        public static let priceIncrease = Self(rawValue: "PRICE_INCREASE")
        
        /// Applies to the DID_FAIL_TO_RENEW notificationType.
        /// A notification with this subtype indicates that the subscription failed to renew due to a billing issue;
        /// continue to provide access to the subscription during the grace period.
        public static let gracePeriod = Self(rawValue: "GRACE_PERIOD")
        
        /// Applies to the DID_RENEW notificationType.
        /// A notification with this subtype indicates that the expired subscription
        /// which previously failed to renew now successfully renewed.
        public static let billingRecovery = Self(rawValue: "BILLING_RECOVERY")
        
        /// Applies to the PRICE_INCREASE notificationType.
        /// A notification with this subtype indicates that the system informed the user of the subscription price increase,
        /// but the user hasn’t yet accepted it.
        public static let pending = Self(rawValue: "PENDING")
        
        /// Applies to the PRICE_INCREASE notificationType.
        /// A notification with this subtype indicates that the user accepted the subscription price increase.
        public static let accepted = Self(rawValue: "ACCEPTED")
    }
}
