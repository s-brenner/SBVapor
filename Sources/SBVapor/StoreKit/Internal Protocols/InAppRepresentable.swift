
protocol InAppRepresentable:
    PurchaseCancellable,
    PurchaseExpirable,
    PurchaseAutoRenewable,
    OriginalPurchaseDateRepresentable,
    OriginalTransactionIdentifiable,
    ProductIdentifiable,
    PromotionalOfferIdentifiable,
    PurchaseDateRepresentable,
    Quantifiable,
    TransactionIdentifiable,
    WebOrderLineItemIdentifiable { }
