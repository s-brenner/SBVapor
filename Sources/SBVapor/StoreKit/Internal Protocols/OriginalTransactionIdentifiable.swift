
protocol OriginalTransactionIdentifiable {
    
    /**
     The transaction identifier of the original purchase.
     
     This value is identical to the `transactionID` except when the user restores a purchase or renews a subscription. This value has the same format as the transaction’s `transactionIdentifier` property; however, the values may not be the same. For auto-renewable subscription transactions, this value also appears in the `pendingRenewalInfo` portion of the response.
     
     You can use this value to:
     
     - Match a transaction found in the receipt to a server-to-server notification event. For more information, see Enabling App Store Server Notifications.
     
     - Manage auto-renewable subscriptions. Store this value, product_id, expires_date_ms, and purchase_date_ms for each transaction for each customer, as a best practice.
     
     - Identify a subscription with the product_id in the pending_renewal_info section. Do not rely on the original_transaction_id value on its own. Treat this purchase as a new subscription when you see a new original_transaction_id value for a product_id.
     
     - Differentiate a purchase transaction from a restore or a renewal transaction. In a purchase transaction, the transaction_id always matches the original_transaction_id. For subscriptions, it indicates the first subscription purchase. For a restore or renewal, the transaction_id does not match the original_transaction_id.
     
     - Identify one or more renewals for the same subscription.
     */
    var originalTransactionID: String? { get }
}
