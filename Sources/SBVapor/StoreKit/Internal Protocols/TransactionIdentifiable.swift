
protocol TransactionIdentifiable {
    
    /**
     A unique identifier for a transaction such as a purchase, restore, or renewal.
     
     This value has the same format as the transaction’s transactionIdentifier property; however, the values may not be the same.
     
     You can use this value to:
     
     - Manage subscribers in your account database. Store the transaction_id, original_transaction_id, and product_id for each transaction, as a best practice to store transaction records for each customer. App Store generates a new value for transaction_id every time the subscription automatically renews or is restored on a new device.
     
     - Differentiate a purchase transaction from a restore or a renewal transaction. In a purchase transaction, the transaction_id always matches the original_transaction_id. For subscriptions, it indicates the first subscription purchase. For a restore or renewal, the transaction_id does not match the original_transaction_id. If a user restores or renews the same purchase multiple times, each restore or renewal has a different transaction_id.
     */
    var transactionID: String? { get }
}
