
protocol PurchaseExpirable {
    
    /**
     The time a subscription expires or renews.
     
     You can use this date value to:
     - Manage auto-renewable subscriptions. Store this value, originalTransactionID, productID, and purchaseDate for each subscription, as a best practice.
     - Identify the date the subscription renews or expires.
     - Determine a user's access to content or a service by comparing this date to the current date. After validating the latest receipt, continue providing service if the date is in the future. If the subscription expiration date for the latest renewal transaction has passed, the subscription has expired.
     */
    var expiresDate: Date? { get }
}
