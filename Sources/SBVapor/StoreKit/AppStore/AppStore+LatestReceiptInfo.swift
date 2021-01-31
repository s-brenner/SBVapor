import Vapor

public extension Application.AppStore {
    
    struct LatestReceiptInfo: Content, LatestReceiptInfoRepresentable {
        
        public let cancellationDate: Date?
        public let cancellationReason: CancellationReason?
        public let expiresDate: Date?
        public let inAppOwnershipType: InAppOwnershipType?
        public let isInIntroOfferPeriod: Bool?
        public let isTrialPeriod: Bool?
        public let isUpgraded: Bool?
        public let offerCodeReferenceName: String?
        public let originalPurchaseDate: Date?
        public let originalTransactionID: String?
        public let productID: String?
        public let promotionalOfferID: String?
        public let purchaseDate: Date?
        public let quantity: Int?
        public let subscriptionGroupIdentifier: String?
        public let webOrderLineItemID: String?
        public let transactionID: String?
        
        init?(_ latest: InternalLatestReceiptInfo?) {
            guard let latest = latest else { return nil }
            cancellationDate = Date(milliseconds: latest.cancellationDateMilliseconds)
            cancellationReason = CancellationReason(rawValue: latest.cancellationReason ?? "")
            expiresDate = Date(milliseconds: latest.expiresDateMilliseconds)
            inAppOwnershipType = InAppOwnershipType(rawValue: latest.inAppOwnershipType ?? "")
            isInIntroOfferPeriod = latest.isInIntroOfferPeriod?.bool
            isTrialPeriod = latest.isTrialPeriod?.bool
            isUpgraded = latest.isUpgraded?.bool
            offerCodeReferenceName = latest.offerCodeReferenceName
            originalPurchaseDate = Date(milliseconds: latest.originalPurchaseDateMilliseconds)
            originalTransactionID = latest.originalTransactionID
            productID = latest.productID
            promotionalOfferID = latest.promotionalOfferID
            purchaseDate = Date(milliseconds: latest.purchaseDateMilliseconds)
            quantity = latest.quantity?.int
            subscriptionGroupIdentifier = latest.subscriptionGroupIdentifier
            webOrderLineItemID = latest.webOrderLineItemID
            transactionID = latest.transactionID
        }
    }
}

extension Application.AppStore {
    
    struct InternalLatestReceiptInfo: Content {
        
        enum CodingKeys: String, CodingKey {
            case cancellationDate = "cancellation_date"
            case cancellationDateMilliseconds = "cancellation_date_ms"
            case cancellationDatePST = "cancellation_date_pst"
            case cancellationReason = "cancellation_reason"
            case expiresDate = "expires_date"
            case expiresDateMilliseconds = "expires_date_ms"
            case expiresDatePST = "expires_date_pst"
            case inAppOwnershipType = "in_app_ownership_type"
            case isInIntroOfferPeriod = "is_in_intro_offer_period"
            case isTrialPeriod = "is_trial_period"
            case isUpgraded = "is_upgraded"
            case offerCodeReferenceName = "offer_code_ref_name"
            case originalPurchaseDate = "original_purchase_date"
            case originalPurchaseDateMilliseconds = "original_purchase_date_ms"
            case originalPurchaseDatePST = "original_purchase_date_pst"
            case originalTransactionID = "original_transaction_id"
            case productID = "product_id"
            case promotionalOfferID = "promotional_offer_id"
            case purchaseDate = "purchase_date"
            case purchaseDateMilliseconds = "purchase_date_ms"
            case purchaseDatePST = "purchase_date_pst"
            case quantity
            case subscriptionGroupIdentifier = "subscription_group_identifier"
            case webOrderLineItemID = "web_order_line_item_id"
            case transactionID = "transaction_id"
        }
        
        let cancellationDate: String?
        let cancellationDateMilliseconds: String?
        let cancellationDatePST: String?
        let cancellationReason: String?
        let expiresDate: String?
        let expiresDateMilliseconds: String?
        let expiresDatePST: String?
        let inAppOwnershipType: String?
        let isInIntroOfferPeriod: String?
        let isTrialPeriod: String?
        let isUpgraded: String?
        let offerCodeReferenceName: String?
        let originalPurchaseDate: String?
        let originalPurchaseDateMilliseconds: String?
        let originalPurchaseDatePST: String?
        let originalTransactionID: String?
        let productID: String?
        let promotionalOfferID: String?
        let purchaseDate: String?
        let purchaseDateMilliseconds: String?
        let purchaseDatePST: String?
        let quantity: String?
        let subscriptionGroupIdentifier: String?
        let webOrderLineItemID: String?
        let transactionID: String?
    }
}
