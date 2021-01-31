
protocol PurchaseCancellable {
    /**
     The time and date that Apple customer support canceled a transaction or the time and date the user upgraded an auto-renewable subscription.
     
     This field is only present for purchases that Apple refunded to the user.
     
     A canceled in-app purchase remains in the receipt indefinitely. This value is present only if the refund was for a non-consumable product, an auto-renewable subscription, or a non-renewing subscription.
     
     This field is available only in production, and does not appear in sandbox receipts.
     
     You can use this value to:
     - Determine whether to stop providing the content associated with the purchase.
     - Check for any latest renewal transactions, which may indicate the user re-started or upgraded their subscription, for an auto-renewable subscription purchase.
     */
    var cancellationDate: Date? { get }
    
    /// The reason for a refunded transaction. When a customer cancels a transaction, the App Store gives them a refund and provides a value for this key.
    var cancellationReason: CancellationReason? { get }
}

public enum CancellationReason: String, Codable {
    /// Indicates that the transaction was canceled for another reason; for example, if the customer made the purchase accidentally.
    case anotherReason = "0"
    /// Indicates that the customer canceled their transaction due to an actual or perceived issue within your app.
    case issueWithApp = "1"
}
