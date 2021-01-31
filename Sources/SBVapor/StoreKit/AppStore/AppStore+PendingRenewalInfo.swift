import Vapor

public extension Application.AppStore {
    
    struct PendingRenewalInfo: Content, PendingRenewalInfoRepresentable {
        
        public let autoRenewProductID: String?
        public let autoRenewStatus: AutoRenewStatus?
        public let expirationIntent: ExpirationIntent?
        public let gracePeriodExpiresDate: Date?
        public let isInBillingRetryPeriod: Bool?
        public let offerCodeReferenceName: String?
        public let originalTransactionID: String?
        public let priceConsentStatus: PriceConsentStatus?
        public let productID: String?
        
        init?(_ pending: InternalPendingRenewalInfo?) {
            guard let pending = pending else { return nil }
            autoRenewProductID = pending.autoRenewProductID
            autoRenewStatus = AutoRenewStatus(rawValue: pending.autoRenewStatus ?? "")
            expirationIntent = ExpirationIntent(rawValue: pending.expirationIntent ?? "")
            gracePeriodExpiresDate = Date(milliseconds: pending.gracePeriodExpiresDateMilliseconds)
            isInBillingRetryPeriod = pending.isInBillingRetryPeriod?.bool
            offerCodeReferenceName = pending.offerCodeReferenceName
            originalTransactionID = pending.originalTransactionID
            priceConsentStatus = PriceConsentStatus(rawValue: pending.priceConsentStatus ?? "")
            productID = pending.productID
        }
    }
}

extension Application.AppStore {
    
    struct InternalPendingRenewalInfo: Content {
        
        enum CodingKeys: String, CodingKey {
            case autoRenewProductID = "auto_renew_product_id"
            case autoRenewStatus = "auto_renew_status"
            case expirationIntent = "expiration_intent"
            case gracePeriodExpiresDate = "grace_period_expires_date"
            case gracePeriodExpiresDateMilliseconds = "grace_period_expires_date_ms"
            case gracePeriodExpiresDatePST = "grace_period_expires_date_pst"
            case isInBillingRetryPeriod = "is_in_billing_retry_period"
            case offerCodeReferenceName = "offer_code_ref_name"
            case originalTransactionID = "original_transaction_id"
            case priceConsentStatus = "price_consent_status"
            case productID = "product_id"
        }
        
        let autoRenewProductID: String?
        let autoRenewStatus: String?
        let expirationIntent: String?
        let gracePeriodExpiresDate: String?
        let gracePeriodExpiresDateMilliseconds: String?
        let gracePeriodExpiresDatePST: String?
        let isInBillingRetryPeriod: String?
        let offerCodeReferenceName: String?
        let originalTransactionID: String?
        let priceConsentStatus: String?
        let productID: String?
    }
}
