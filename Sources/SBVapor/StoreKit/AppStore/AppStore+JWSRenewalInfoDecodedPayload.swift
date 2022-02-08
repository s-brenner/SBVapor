import JWT

public extension Application.AppStore {
    
    struct JWSRenewalInfoDecodedPayload: JWTPayload {
        
        /// The product ID of the subscription that will automatically renew.
        public let autoRenewPreference: String?
        
        /// A Boolean value that indicates whether the subscription will automatically renew in the next period.
        public let willAutoRenew: Bool
        
        /// The reason the subscription expired.
        public let expirationReason: ExpirationReason?
        
        public let gracePeriodExpirationDate: Date?
        
        public let isInBillingRetry: Bool
        
        /// A string that identifies an offer applied to the next subscription period.
        public let offerID: String?
        
        /// The subscription offer type for the next subscription period.
        public let offerType: Application.AppStore.JWSTransactionDecodedPayload.OfferType?
        
        /// The transaction identifier of the original purchase.
        public let originalTransactionID: String
        
        /// The status that indicates whether a customer has accepted a price increase to a subscription.
        public let priceIncreaseStatus: PriceIncreaseStatus
        
        public let currentProductID: String
        
        public let signedDate: Date
        
        private enum CodingKeys: String, CodingKey {
            case autoRenewProductId
            case autoRenewStatus
            case expirationIntent
            case gracePeriodExpiresDate
            case isInBillingRetryPeriod
            case offerIdentifier
            case offerType
            case originalTransactionId
            case priceIncreaseStatus
            case productId
            case signedDate
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            autoRenewPreference = try values.decode(String.self, forKey: .autoRenewProductId)
            willAutoRenew = try values.decodeIfPresent(Int.self, forKey: .autoRenewStatus) == 1
            expirationReason = try values.decodeIfPresent(forKey: .expirationIntent)
            #warning("Grace period decoding is untested")
            gracePeriodExpirationDate = try values.decodeIfPresent(Date.self, forKey: .gracePeriodExpiresDate)
            isInBillingRetry = try values.decode(Bool.self, forKey: .isInBillingRetryPeriod)
            offerID = try values.decodeIfPresent(String.self, forKey: .offerIdentifier)
            offerType = try values.decodeIfPresent(forKey: .offerType)
            originalTransactionID = try values.decode(String.self, forKey: .originalTransactionId)
            priceIncreaseStatus = try values.decodeIfPresent(forKey: .priceIncreaseStatus) ?? .noIncreasePending
            currentProductID = try values.decode(String.self, forKey: .productId)
            signedDate = try values.decodeMilliseconds(forKey: .signedDate)
        }
        
        public func encode(to encoder: Encoder) throws {
            fatalError("Not implemented")
        }
        
        public func verify(using signer: JWTSigner) throws { }
    }
}

public extension Application.AppStore.JWSRenewalInfoDecodedPayload {
    
    /// The reasons for subscription expirations.
    struct ExpirationReason: Equatable, Hashable, RawRepresentable {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// The customer canceled their subscription.
        public static let autoRenewDisabled = Self(rawValue: 1)
        
        /// Billing error; for example, the customer’s payment information was no longer valid.
        public static let billingError = Self(rawValue: 2)
        
        /// The customer didn’t consent to a recent price increase.
        public static let didNotConsentToPriceIncrease = Self(rawValue: 3)
        
        /// The product wasn’t available for purchase at the time of renewal.
        public static let productUnavailable = Self(rawValue: 4)
    }
    
    /// Status values for a customer’s price increase consent.
    @frozen enum PriceIncreaseStatus: Int {
        /// The customer hasn’t yet responded to the subscription price increase.
        case pending = 0
        /// The customer consented to the subscription price increase.
        case agreed = 1
        /// There’s no pending price increase.
        case noIncreasePending = 2
    }
}
