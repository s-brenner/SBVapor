
protocol LatestReceiptInfoRepresentable:
    PurchaseCancellable,
    PurchaseExpirable,
    InAppOwnershipTypeRepresentable,
    PurchaseAutoRenewable,
    OriginalPurchaseDateRepresentable,
    OriginalTransactionIdentifiable,
    ProductIdentifiable,
    PromotionalOfferIdentifiable,
    PurchaseDateRepresentable,
    Quantifiable,
    WebOrderLineItemIdentifiable,
    TransactionIdentifiable {
    
    /// An indicator that a subscription has been canceled due to an upgrade. This field is only present for upgrade transactions.
    var isUpgraded: Bool? { get }
    
    /// The reference name of a subscription offer that you configured in App Store Connect. This field is present when a customer redeemed a subscription offer code.
    var offerCodeReferenceName: String? { get }
    
    /// The identifier of the subscription group to which the subscription belongs. The value for this field is identical to the subscriptionGroupIdentifier property in SKProduct.
    var subscriptionGroupIdentifier: String? { get }
}
