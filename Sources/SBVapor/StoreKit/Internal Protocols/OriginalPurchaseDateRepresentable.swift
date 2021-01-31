
protocol OriginalPurchaseDateRepresentable {
    
    /**
     The time of the original app purchase.
     
     For an auto-renewable subscription, this value indicates the date of the subscription's initial purchase. The original purchase date applies to all product types and remains the same in all transactions for the same product ID.
    */
    var originalPurchaseDate: Date? { get }
}
