
protocol PurchaseAutoRenewable {
    
    /**
     An indicator of whether an auto-renewable subscription is in the introductory price period.
     
     You can use this value to determine if the user is eligible for introductory pricing.
     */
    var isInIntroOfferPeriod: Bool? { get }
    
    /**
     An indicator of whether an auto-renewable subscription is in the free trial period.
     
     You can use this value to determine whether the specific record is in a subscription trial period.
     */
    var isTrialPeriod: Bool? { get }
}
