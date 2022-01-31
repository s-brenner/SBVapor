//import JWT
//import StoreKit
//
//public extension Application.AppStore {
//    
//    struct JWSRenewalInfoDecodedPayload: JWTPayload {
//        
//        /// The product ID of the subscription that will automatically renew.
//        public let autoRenewPreference: String?
//        
//        /// A Boolean value that indicates whether the subscription will automatically renew in the next period.
//        public let willAutoRenew: Bool
//        
//        /// The reason the subscription expired.
//        public let expirationReason: Product.SubscriptionInfo.RenewalInfo.ExpirationReason
//        
//        public let gracePeriodExpirationDate: Date?
//        
//        public let isInBillingRetry: Bool
//        
//        /// A string that identifies an offer applied to the next subscription period.
//        public let offerID: String?
//        
//        /// The subscription offer type for the next subscription period.
//        public let offerType: Transaction.OfferType?
//        
//        /// The transaction identifier of the original purchase.
//        public let originalTransactionID: String
//        
//        /// The status that indicates whether a customer has accepted a price increase to a subscription.
//        public let priceIncreaseStatus: Product.SubscriptionInfo.RenewalInfo.PriceIncreaseStatus
//        
//        public let currentProductID: String
//        
//        public let signedDate: Date
//        
//        private enum CodingKeys: String, CodingKey {
//            case autoRenewProductId
//            case autoRenewStatus
//            case expirationIntent
//            case gracePeriodExpiresDate
//            case isInBillingRetryPeriod
//            case offerIdentifier
//            case offerType
//            case originalTransactionId
//            case priceIncreaseStatus
//            case productId
//            case signedDate
//        }
//        
//        public init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            autoRenewPreference = try values.decode(String.self, forKey: .autoRenewProductId)
//            willAutoRenew = try values.decode(Int.self, forKey: .autoRenewStatus) == 1
//            expirationReason = try values.decode(forKey: .expirationIntent)
//            #warning("Grace period decoding is untested")
//            gracePeriodExpirationDate = try values.decodeIfPresent(Date.self, forKey: .gracePeriodExpiresDate)
//            isInBillingRetry = try values.decode(Bool.self, forKey: .isInBillingRetryPeriod)
//            offerID = try values.decodeIfPresent(String.self, forKey: .offerIdentifier)
//            offerType = try values.decodeIfPresent(forKey: .offerType)
//            originalTransactionID = try values.decode(String.self, forKey: .originalTransactionId)
//            if let _priceIncreaseStatus = try values.decodeIfPresent(Int.self, forKey: .priceIncreaseStatus) {
//                priceIncreaseStatus = _priceIncreaseStatus == 1 ? .agreed : .pending
//            }
//            else {
//                priceIncreaseStatus = .noIncreasePending
//            }
//            currentProductID = try values.decode(String.self, forKey: .productId)
//            signedDate = try values.decodeMilliseconds(forKey: .signedDate)
//        }
//        
//        public func encode(to encoder: Encoder) throws {
//            fatalError("Not implemented")
//        }
//        
//        public func verify(using signer: JWTSigner) throws { }
//    }
//}
