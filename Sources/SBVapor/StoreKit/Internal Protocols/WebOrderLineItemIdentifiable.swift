
protocol WebOrderLineItemIdentifiable {
    
    /**
     A unique identifier for purchase events across devices, including subscription-renewal events. This value is the primary key for identifying subscription purchases.
     */
    var webOrderLineItemID: String? { get }
}
