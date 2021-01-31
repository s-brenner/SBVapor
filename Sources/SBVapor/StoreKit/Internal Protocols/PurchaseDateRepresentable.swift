
protocol PurchaseDateRepresentable {
    
    /**
     For consumable, non-consumable, and non-renewing subscription products, the time the App Store charged the user's account for a purchased or restored product. For auto-renewable subscriptions, the time the App Store charged the user’s account for a subscription purchase or renewal after a lapse.
     */
    var purchaseDate: Date? { get }
}
