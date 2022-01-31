//import JWT
//import StoreKit
//
//public extension Application.AppStore {
//    
//    struct HistoryResponse: Decodable {
//        
//        private enum CodingKeys: String, CodingKey {
//            case appAppleId
//            case bundleId
//            case environment
//            case hasMore
//            case revision
//            case signedTransactions
//        }
//        
//        /// The app’s identifier in the App Store.
//        public let appAppleID: Int?
//        
//        /// The bundle identifier of the app.
//        public let bundleID: String
//        
//        /// The server environment in which you’re making the request, whether sandbox or production.
//        public let environment: Environment
//        
//        /// A Boolean value that indicates whether the App Store has more transactions than are returned in this request.
//        public let hasMore: Bool
//        
//        /// A token you use in a query to request the next set of transactions from the Get Transaction History endpoint.
//        public let revision: String
//        
//        /// An array of in-app purchase transactions for the customer.
//        public let transactions: [JWSTransactionDecodedPayload]
//        
//        public init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            appAppleID = try values.decodeIfPresent(Int.self, forKey: .appAppleId)
//            bundleID = try values.decode(String.self, forKey: .bundleId)
//            environment = try values.decode(forKey: .environment)
//            hasMore = try values.decode(Bool.self, forKey: .hasMore)
//            revision = try values.decode(String.self, forKey: .revision)
//            let signers = JWTSigners()
//            transactions = try values
//                .decode([String].self, forKey: .signedTransactions)
//                .map { try signers.unverified($0, as: JWSTransactionDecodedPayload.self) }
//        }
//    }
//}
