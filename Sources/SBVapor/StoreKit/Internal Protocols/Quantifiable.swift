
protocol Quantifiable {
    
    /**
     The number of consumable products purchased. This value corresponds to the quantity property of the SKPayment object stored in the transaction's payment property. The value is usually 1 unless modified with a mutable payment. The maximum value is 10.
     */
    var quantity: Int? { get }
}
