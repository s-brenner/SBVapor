//import JWT
//import StoreKit
//
//public extension Application.AppStore {
//    
//    struct StatusResponse: Decodable {
//        
//        /// An array of subscription information, including signed transaction information and signed renewal information.
//        public let data: [SubscriptionGroupIdentifierItem]
//        
//        /// The server environment in which you’re making the request, whether sandbox or production.
//        public let environment: Environment
//        
//        /// The app’s identifier in the App Store.
//        public let appAppleID: Int?
//        
//        /// The bundle identifier of the app.
//        public let bundleID: String
//        
//        private enum CodingKeys: String, CodingKey {
//            case data
//            case environment
//            case appAppleId
//            case bundleId
//        }
//        
//        public init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            data = try values.decode([SubscriptionGroupIdentifierItem].self, forKey: .data)
//            environment = try values.decode(forKey: .environment)
//            appAppleID = try values.decodeIfPresent(Int.self, forKey: .appAppleId)
//            bundleID = try values.decode(String.self, forKey: .bundleId)
//        }
//    }
//}
//
//public extension Application.AppStore.StatusResponse {
//    
//    struct SubscriptionGroupIdentifierItem: Decodable {
//        
//        /// The subscription group identifier of the subscriptions in the lastTransactions array.
//        public let subscriptionGroupID: String
//        
//        /// An array of the most recent signed transaction information and
//        /// signed renewal information for all subscriptions in the subscription group.
//        public let lastTransactions: [LastTransactionItem]
//        
//        private enum CodingKeys: String, CodingKey {
//            case subscriptionGroupID = "subscriptionGroupIdentifier"
//            case lastTransactions
//        }
//    }
//}
//
//public extension Application.AppStore.StatusResponse.SubscriptionGroupIdentifierItem {
//    
//    struct LastTransactionItem: Decodable {
//        
//        /// The original transaction identifier of the subscription.
//        public let originalTransactionID: String
//        
//        /// The status of the subscription.
//        public let status: Product.SubscriptionInfo.RenewalState
//        
//        /// The subscription renewal information.
//        public let renewalInfo: Application.AppStore.JWSRenewalInfoDecodedPayload
//        
//        /// The transaction information.
//        public let transaction: Application.AppStore.JWSTransactionDecodedPayload
//        
//        private enum CodingKeys: String, CodingKey {
//            case originalTransactionId
//            case status
//            case signedRenewalInfo
//            case signedTransactionInfo
//        }
//        
//        public init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            originalTransactionID = try values.decode(String.self, forKey: .originalTransactionId)
//            status = try values.decode(forKey: .status)
//            renewalInfo = try values.decode(forKey: .signedRenewalInfo)
//            transaction = try values.decode(forKey: .signedTransactionInfo)
//        }
//    }
//}
//
//extension KeyedDecodingContainer {
//    
//    func decode<Payload>(
//        _ type: Payload.Type = Payload.self,
//        using signers: JWTSigners = .init(),
//        forKey key: Key
//    ) throws -> Payload
//    where Payload: JWTPayload {
//        let token = try decode(String.self, forKey: key)
//        return try signers.unverified(token, as: Payload.self)
//    }
//}
