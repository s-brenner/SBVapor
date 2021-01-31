
protocol PendingRenewalInfoRepresentable:
    OriginalTransactionIdentifiable,
    ProductIdentifiable,
    ExpirationIntentRepresentable {
    
    /**
     The current renewal preference for the auto-renewable subscription.
     
     The value for this key corresponds to the `productIdentifier` property of the product that the customer’s subscription renews. This field is only present if the user downgrades or crossgrades to a subscription of a different duration for the subsequent subscription period.
     */
    var autoRenewProductID: String? { get }
    
    /**
     The renewal status for the auto-renewable subscription.
     
     The value for this field should not be interpreted as the customer’s subscription status. You can use this value to display an alternative subscription product in your app, such as a lower-level subscription plan to which the user can downgrade from their current plan.
     
     Consider presenting an attractive upgrade or downgrade offer in the same subscription group, if the `autoRenewStatus` value is `“customerDisabled”`. See [Engineering Subscriptions](https://developer.apple.com/videos/play/wwdc2018/705/) from WWDC 2018 for more information.
     */
    var autoRenewStatus: AutoRenewStatus? { get }
    
    /**
     The time at which the grace period for subscription renewals expires.
     
     This key is only present for apps that have Billing Grace Period enabled and when the user experiences a billing error at the time of renewal.
     */
    var gracePeriodExpiresDate: Date? { get }
    
    /**
     An indicator of whether an auto-renewable subscription is in the billing retry period.
     
     This field indicates whether Apple is attempting to renew an expired subscription automatically. If the customer’s subscription failed to renew because the App Store was unable to complete the transaction, this value reflects whether the App Store is still trying to renew the subscription.
     
     The subscription retry flag is solely indicative of whether a subscription is in a billing retry state. Use this value in conjunction with `expirationIntent`, `expiresDate`, and `transactionID` for more insight.
     
     You can use this field to:
     - Determine that the user has been billed successfully, if this field has been removed and there is a new transaction with a future `expiresDate`.
     - Inform the user that there may be an issue with their billing information, if the value is `true`. For example, an expired credit card or insufficient balance could prevent this customer's account from being billed.
     - Implement a grace period to improve recovery, if the value is `true` and the `expiresDate` is in the past. A grace period is free or limited subscription access while a subscriber is in a billing retry state. See [Engineering Subscriptions](https://developer.apple.com/videos/play/wwdc2018/705/) from WWDC 2018 for more information.
     */
    var isInBillingRetryPeriod: Bool? { get }
    
    /**
     The offer-reference name of the subscription offer code that the customer redeemed.
     
     When a customer successfully redeems an offer code, this field is present in the receipt and contains the reference name of the offer. You establish the offer reference name in App Store Connect when you configure offers and create the offer codes. For more information about setting up offers, see [Set Up Offer Codes](https://help.apple.com/app-store-connect/#/dev6a098e4b1).
     
     Use this value to:
     - Determine whether the sale of the subscription was from an offer code campaign.
     - Determine the specific offer the customer redeemed.
     - Keep track of subscription-offer codes a customer has redeemed, to limit discounts you offer, according to your business model.
     
     For more information on offers and offer codes, see [Implementing Offer Codes in Your App](https://developer.apple.com/documentation/storekit/in-app_purchase/subscriptions_and_offers/implementing_offer_codes_in_your_app).
     */
    var offerCodeReferenceName: String? { get }
    
    /**
     The price consent status for a subscription price increase.
     
     This field is only present if the customer was notified of the price increase. The default value is `customerNotified` and changes to `customerConsents` if the customer consents.
     */
    var priceConsentStatus: PriceConsentStatus? { get }
}

public enum AutoRenewStatus: String, Codable, CustomStringConvertible {
    /// The subscription will renew at the end of the current subscription period.
    case willRenew = "1"
    /// The customer has turned off automatic renewal for the subscription.
    case customerDisabled = "0"
    
    public var description: String {
        switch self {
        case .willRenew: return "The subscription will renew at the end of the current subscription period."
        case .customerDisabled: return "The customer has turned off automatic renewal for the subscription."
        }
    }
}

public enum PriceConsentStatus: String, Codable {
    case customerNotified = "0"
    case customerConsents = "1"
}
