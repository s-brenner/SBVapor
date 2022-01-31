import JWT
import StoreKit

public extension Application.AppStore {
    
    struct JWSTransactionDecodedPayload: JWTPayload {
        
        /// A UUID that associates the transaction with a user on your own service.
        public let appAccountToken: UUID?
        
        /// The bundle identifier of the app.
        public let bundleID: String
        
        /// The date the subscription expires or renews.
        public let expirationDate: Date?
        
        /// A value that indicates whether the transaction was purchased by the user,
        /// or is made available to them through Family Sharing.
        public let ownershipType: Transaction.OwnershipType
        
        /// The Boolean value that indicates whether the user upgraded to another subscription.
        public let isUpgraded: Bool
        
        /// A string that identifies an offer applied to the current subscription.
        public let offerID: String?
        
        /// The subscription offer type for the current subscription period.
        public let offerType: Transaction.OfferType?
        
        /// The date of purchase for the original transaction.
        public let originalPurchaseDate: Date
        
        /// The original transaction identifier of a purchase.
        public let originalID: String
        
        /// The product identifier.
        public let productID: String
        
        /// The date that App Store charged the user’s account for a purchased or restored product,
        /// or for a subscription purchase or renewal after a lapse.
        public let purchaseDate: Date
        
        /// The number of consumable products purchased.
        public let quantity: Int
        
        /// The date that App Store refunded the transaction or revoked it from family sharing.
        public let revocationDate: Date?
        
        /// The reason that App Store refunded the transaction or revoked it from family sharing.
        public let revocationReason: Transaction.RevocationReason?
        
        /// The date that the App Store signed the JSON Web Signature (JWS) data.
        public let signedDate: Date
        
        /// The identifier of the subscription group that the subscription belongs to.
        public let subscriptionGroupID: String?
        
        /// The unique identifier for the transaction.
        public let id: String
        
        /// The type of the in-app purchase.
        public let productType: Product.ProductType
        
        /// A unique ID that identifies subscription purchase events across devices, including subscription renewals.
        public let webOrderLineItemID: String?
        
        private enum CodingKeys: String, CodingKey {
            case appAccountToken
            case bundleId
            case expiresDate
            case inAppOwnershipType
            case isUpgraded
            case offerIdentifier
            case offerType
            case originalPurchaseDate
            case originalTransactionId
            case productId
            case purchaseDate
            case quantity
            case revocationDate
            case revocationReason
            case signedDate
            case subscriptionGroupIdentifier
            case transactionId
            case type
            case webOrderLineItemId
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            appAccountToken = try values.decodeIfPresent(UUID.self, forKey: .appAccountToken)
            bundleID = try values.decode(String.self, forKey: .bundleId)
            expirationDate = try values.decodeMillisecondsIfPresent(forKey: .expiresDate)
            ownershipType = try values.decode(forKey: .inAppOwnershipType)
            isUpgraded = try values.decodeIfPresent(Bool.self, forKey: .isUpgraded) ?? false
            offerID = try values.decodeIfPresent(String.self, forKey: .offerIdentifier)
            offerType = try values.decodeIfPresent(forKey: .offerType)
            originalPurchaseDate = try values.decodeMilliseconds(forKey: .originalPurchaseDate)
            originalID = try values.decode(String.self, forKey: .originalTransactionId)
            productID = try values.decode(String.self, forKey: .productId)
            purchaseDate = try values.decodeMilliseconds(forKey: .purchaseDate)
            quantity = try values.decode(Int.self, forKey: .quantity)
            revocationDate = try values.decodeMillisecondsIfPresent(forKey: .revocationDate)
            revocationReason = try values.decodeIfPresent(forKey: .revocationReason)
            signedDate = try values.decodeMilliseconds(forKey: .signedDate)
            subscriptionGroupID = try values.decodeIfPresent(String.self, forKey: .subscriptionGroupIdentifier)
            id = try values.decode(String.self, forKey: .transactionId)
            productType = try values.decode(forKey: .type)
            webOrderLineItemID = try values.decodeIfPresent(String.self, forKey: .webOrderLineItemId)
        }
        
        public func encode(to encoder: Encoder) throws {
            fatalError("Not implemented")
        }
        
        public func verify(using signer: JWTSigner) throws { }
    }
}
