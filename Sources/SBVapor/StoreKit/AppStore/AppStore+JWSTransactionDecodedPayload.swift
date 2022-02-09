import JWT

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
        public let ownershipType: OwnershipType
        
        /// The Boolean value that indicates whether the user upgraded to another subscription.
        public let isUpgraded: Bool
        
        /// A string that identifies an offer applied to the current subscription.
        public let offerID: String?
        
        /// The subscription offer type for the current subscription period.
        public let offerType: OfferType?
        
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
        public let revocationReason: RevocationReason?
        
        /// The date that the App Store signed the JSON Web Signature (JWS) data.
        public let signedDate: Date
        
        /// The identifier of the subscription group that the subscription belongs to.
        public let subscriptionGroupID: String?
        
        /// The unique identifier for the transaction.
        public let id: String
        
        /// The type of the in-app purchase.
        public let productType: ProductType
        
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

public extension Application.AppStore.JWSTransactionDecodedPayload {
    
    struct OfferType: Equatable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// An introductory offer.
        public static let introductory = Self(rawValue: 1)
        
        /// A promotional offer.
        public static let promotional = Self(rawValue: 2)
        
        /// An offer with a subscription offer code.
        public static let code = Self(rawValue: 3)
        
        public var description: String {
            switch self {
            case .introductory: return "Introductory"
            case .promotional: return "Promotional"
            case .code: return "Code"
            default: return "Unknown"
            }
        }
        
        public var debugDescription: String { "(\(rawValue)) \(description)" }
    }
    
    struct OwnershipType: Equatable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {
        
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        /// The transaction belongs to a family member who benefits from service.
        public static let familyShared = Self(rawValue: "FAMILY_SHARED")
        
        /// The transaction belongs to the purchaser.
        public static let purchased = Self(rawValue: "PURCHASED")
        
        public var description: String {
            switch self {
            case .familyShared: return "Family Shared"
            case .purchased: return "Purchased"
            default: return "Unknown"
            }
        }
        
        public var debugDescription: String { rawValue }
    }
    
    /// Reasons why the App Store may refund a transaction or revoke it from family sharing.
    struct RevocationReason: Equatable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// Apple Support refunded the transaction on behalf of the customer due to an actual or perceived issue within your app.
        public static let developerIssue = Self(rawValue: 1)
        
        /// Apple Support refunded the transaction on behalf of the customer for other reasons; for example, an accidental purchase.
        public static let other = Self(rawValue: 0)
        
        public var description: String {
            switch self {
            case .developerIssue: return "Developer Issue"
            case .other: return "Other"
            default: return "Unknown"
            }
        }
        
        public var debugDescription: String { "(\(rawValue)) \(description)" }
    }
    
    /// The types of in-app purchases.
    struct ProductType: Equatable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {
        
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        /// An auto-renewable subscription.
        public static let autoRenewable = Self(rawValue: "Auto-Renewable Subscription")
        
        /// A non-consumable in-app purchase.
        public static let nonConsumable = Self(rawValue: "Non-Consumable")
        
        /// A consumable in-app purchase.
        public static let consumable = Self(rawValue: "Consumable")
        
        /// A non-renewing subscription.
        public static let nonRenewing = Self(rawValue: "Non-Renewing Subscription")
        
        public var description: String { rawValue }
        
        public var debugDescription: String { rawValue }
    }
}
