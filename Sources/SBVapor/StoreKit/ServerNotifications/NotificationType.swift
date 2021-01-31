public extension AppStoreServerNotifications {
    
    enum NotificationType: String, Codable {
        /// Indicates that either Apple customer support canceled the subscription or the user upgraded their subscription. The cancellation_date key contains the date and time of the change.
        case cancel = "CANCEL"
        
        /// Indicates that the customer made a change in their subscription plan that takes effect at the next renewal. The currently active plan isn’t affected.
        case didChangeRenewalPreference = "DID_CHANGE_RENEWAL_PREF"
        
        /// Indicates a change in the subscription renewal status. In the JSON response, check auto_renew_status_change_date_ms to know the date and time of the last status update. Check auto_renew_status to know the current renewal status.
        case didChangeRenewalStatus = "DID_CHANGE_RENEWAL_STATUS"
        
        /// Indicates a subscription that failed to renew due to a billing issue. Check is_in_billing_retry_period to know the current retry status of the subscription. Check grace_period_expires_date to know the new service expiration date if the subscription is in a billing grace period.
        case didFailToRenew = "DID_FAIL_TO_RENEW"
        
        /// Indicates a successful automatic renewal of an expired subscription that failed to renew in the past. Check expires_date to determine the next renewal date and time.
        case didRecover = "DID_RECOVER"
        
        /// Indicates that a customer’s subscription has successfully auto-renewed for a new transaction period.
        case didRenew = "DID_RENEW"
        
        /// Occurs at the user’s initial purchase of the subscription. Store latest_receipt on your server as a token to verify the user’s subscription status at any time by validating it with the App Store.
        case initialBuy = "INITIAL_BUY"
        
        /// Indicates the customer renewed a subscription interactively, either by using your app’s interface, or on the App Store in the account’s Subscriptions settings. Make service available immediately.
        case interactiveRenewal = "INTERACTIVE_RENEWAL"
        
        /// Indicates that App Store has started asking the customer to consent to your app’s subscription price increase. In the [unified_receipt.Pending_renewal_info](https://developer.apple.com/documentation/appstoreservernotifications/unified_receipt/pending_renewal_info) object, the price_consent_status value is 0, indicating that App Store is asking for the customer’s consent, and hasn’t received it. The subscription won’t auto-renew unless the user agrees to the new price. When the customer agrees to the price increase, the system sets price_consent_status to 1. Check the receipt using [verifyReceipt](https://developer.apple.com/documentation/appstorereceipts/verifyreceipt) to view the updated price-consent status.
        case priceIncreaseConsent = "PRICE_INCREASE_CONSENT"
        
        /// Indicates that App Store successfully refunded a transaction. The cancellation_date_ms contains the timestamp of the refunded transaction. The original_transaction_id and product_id identify the original transaction and product. The cancellation_reason contains the reason.
        case refund = "REFUND"
        
        /// Indicates that an in-app purchase the user was entitled to through Family Sharing is no longer available through sharing. StoreKit sends this notification when a purchaser disabled Family Sharing for a product, the purchaser (or family member) left the family group, or the purchaser asked for and received a refund. Your app will also receive a [paymentQueue(_:didRevokeEntitlementsForProductIdentifiers:)](https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver/3564804-paymentqueue) call. For more information about Family Sharing, see [Supporting Family Sharing in Your App](https://developer.apple.com/documentation/storekit/in-app_purchase/supporting_family_sharing_in_your_app).
        case revoke = "REVOKE"
    }
}
