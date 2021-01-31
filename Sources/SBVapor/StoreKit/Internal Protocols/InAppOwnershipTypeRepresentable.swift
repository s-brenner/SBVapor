
protocol InAppOwnershipTypeRepresentable {
    
    /**
     A value that indicates whether the user is the purchaser of the product, or is a family member with access to the product through Family Sharing.
     */
    var inAppOwnershipType: InAppOwnershipType? { get }
}

/// The relationship of the user with the family-shared purchase to which they have access.
public enum InAppOwnershipType: String, Codable, CustomStringConvertible {
    /// The transaction belongs to a family member who benefits from service.
    case familyShared = "FAMILY_SHARED"
    /// The transaction belongs to the purchaser.
    case purchased = "PURCHASED"
    
    public var description: String {
        switch self {
        case .familyShared: return "Family Shared"
        case .purchased: return "Purchased"
        }
    }
}
