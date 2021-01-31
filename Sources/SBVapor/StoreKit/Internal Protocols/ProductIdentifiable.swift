
protocol ProductIdentifiable {
    
    /**
     The unique identifier of the product purchased. You provide this value when creating the product in App Store Connect, and it corresponds to the productIdentifier property of the [SKPayment](https://developer.apple.com/documentation/storekit/skpayment) object stored in the transaction's payment property.
     */
    var productID: String? { get }
}
