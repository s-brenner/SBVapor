
protocol PromotionalOfferIdentifiable {
    
    /**
     The identifier of the promotional offer for an auto-renewable subscription that the user redeemed.
     
     You provide this value in the Promotional Offer Identifier field when you create the promotional offer in App Store Connect.
     
     You can use the promotional offer ID value to:
     
     - Confirm that the sale of the subscription was from a promotional offer.
     
     - Confirm which promotional offer the user redeemed.
     
     - Keep track of the promotional offers that a user has redeemed to limit discounts you offer, according to your business model.
     */
    var promotionalOfferID: String? { get }
}
