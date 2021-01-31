
protocol ExpirationIntentRepresentable {
    
    /**
     The reason a subscription expired.
     
     You can use this value to:
     - Decide whether to survey the subscribers who have opted in to an account on your system or show alternative subscription products within the same group, if the value is `customerVoluntarilyCancelled`.
     - Decide whether to show the same or alternative subscription products, if the value is `billingError`, since the user did not actively make the choice to unsubscribe.
     - Decide whether to present a subscription offer to win back the user if the value is `customerVoluntarilyCancelled`.
     
     See [Engineering Subscriptions](https://developer.apple.com/videos/play/wwdc2018/705/) from WWDC 2018 and [Implementing Promotional Offers in Your App](https://developer.apple.com/documentation/storekit/in-app_purchase/subscriptions_and_offers/implementing_promotional_offers_in_your_app) for more guidance.
     */
    var expirationIntent: Application.AppStore.ExpirationIntent? { get }
}

public extension Application.AppStore {
    
    enum ExpirationIntent: String, Codable {
        /// The customer voluntarily canceled their subscription.
        case customerVoluntarilyCancelled = "1"
        /// Billing error; for example, the customer's payment information was no longer valid.
        case billingError = "2"
        /// The customer did not agree to a recent price increase.
        case customerDidNotAgreeToRecentPriceIncrease = "3"
        /// The product was not available for purchase at the time of renewal.
        case productNotAvailableAtTimeOfRenewal = "4"
        /// Unknown error.
        case unknownError = "5"
    }
}
