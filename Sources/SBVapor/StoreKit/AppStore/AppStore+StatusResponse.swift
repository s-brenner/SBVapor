import JWT

public extension Application.AppStore {
    
    struct StatusResponse: Decodable {
        
        /// An array of subscription information, including signed transaction information and signed renewal information.
        public let data: [SubscriptionGroupIdentifierItem]
        
        /// The server environment in which you’re making the request, whether sandbox or production.
        public let environment: Environment
        
        /// The app’s identifier in the App Store.
        public let appAppleID: Int?
        
        /// The bundle identifier of the app.
        public let bundleID: String
        
        private enum CodingKeys: String, CodingKey {
            case data
            case environment
            case appAppleId
            case bundleId
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try values.decode([SubscriptionGroupIdentifierItem].self, forKey: .data)
            environment = try values.decode(forKey: .environment)
            appAppleID = try values.decodeIfPresent(Int.self, forKey: .appAppleId)
            bundleID = try values.decode(String.self, forKey: .bundleId)
        }
    }
}

public extension Application.AppStore.StatusResponse {
    
    struct SubscriptionGroupIdentifierItem: Decodable {
        
        /// The subscription group identifier of the subscriptions in the lastTransactions array.
        public let subscriptionGroupID: String
        
        /// An array of the most recent signed transaction information and
        /// signed renewal information for all subscriptions in the subscription group.
        public let lastTransactions: [LastTransactionItem]
        
        private enum CodingKeys: String, CodingKey {
            case subscriptionGroupID = "subscriptionGroupIdentifier"
            case lastTransactions
        }
    }
}

public extension Application.AppStore.StatusResponse.SubscriptionGroupIdentifierItem {
    
    struct LastTransactionItem: Decodable {
        
        /// The original transaction identifier of the subscription.
        public let originalTransactionID: String
        
        /// The status of the subscription.
        public let status: RenewalState
        
        /// The subscription renewal information.
        public let renewalInfo: Application.AppStore.JWSRenewalInfoDecodedPayload
        
        /// The transaction information.
        public let transaction: Application.AppStore.JWSTransactionDecodedPayload
        
        private enum CodingKeys: String, CodingKey {
            case originalTransactionId
            case status
            case signedRenewalInfo
            case signedTransactionInfo
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            originalTransactionID = try values.decode(String.self, forKey: .originalTransactionId)
            status = try values.decode(forKey: .status)
            renewalInfo = try values.decode(forKey: .signedRenewalInfo)
            transaction = try values.decode(forKey: .signedTransactionInfo)
        }
    }
}

public extension Application.AppStore.StatusResponse.SubscriptionGroupIdentifierItem.LastTransactionItem {
    
    /// The renewal states of auto-renewable subscriptions.
    struct RenewalState: Equatable, Hashable, RawRepresentable {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// The subscription is active.
        public static let subscribed = Self(rawValue: 1)
        
        /// The subscription is expired.
        public static let expired = Self(rawValue: 2)
        
        /// The subscription is in a billing retry period.
        public static let inBillingRetryPeriod = Self(rawValue: 3)
        
        /// The subscription is in a billing grace period.
        public static let inGracePeriod = Self(rawValue: 4)
        
        /// The subscription is revoked.
        public static let revoked = Self(rawValue: 5)
    }
}
