//public enum AppStoreReceipts {
//
//    // MARK: - RequestBody
//    /// The JSON contents you submit with the request to the App Store.
//    public struct RequestBody: Content {
//
//        enum CodingKeys: String, CodingKey {
//            case receiptData = "receipt-data"
//            case password
//            case excludeOldTransactions = "exclude-old-transactions"
//        }
//
//        /// (Required) The Base64-encoded receipt data.
//        public let receiptData: Data
//
//        /// (Required) Your app’s shared secret, which is a hexadecimal string.
//        public let password: String
//
//        /// Set this value to true for the response to include only the latest renewal transaction for any subscriptions.
//        ///
//        /// Use this field only for app receipts that contain auto-renewable subscriptions.
//        public let excludeOldTransactions: Bool?
//
//        public init(
//            receiptData: Data,
//            password: String,
//            excludeOldTransactions: Bool? = nil
//        ) {
//            self.receiptData = receiptData
//            self.password = password
//            self.excludeOldTransactions = excludeOldTransactions
//        }
//    }
//
//    // MARK: - ResponseBody
//    public struct ResponseBody: Content, PrettyPrintable {
//
//        /// The environment for which the receipt was generated.
//        public let environment: Environment?
//        public typealias Environment = Application.AppStore.Environment
//
//        /**
//         An indicator that an error occurred during the request.
//
//         A value of 1 indicates a temporary issue; retry validation for this receipt at a later time. A value of 0 indicates an unresolvable issue; do not retry validation for this receipt. Only applicable to status codes 21100-21199.
//         */
//        public let isRetryable: Bool
//
//        /// The latest Base64 encoded app receipt. Only returned for receipts that contain auto-renewable subscriptions.
//        public let latestReceipt: String
//
//        /**
//         An array that contains all in-app purchase transactions. This excludes transactions for consumable products that have been marked as finished by your app. Only returned for receipts that contain auto-renewable subscriptions.
//         */
//        public let latestReceiptInfo: [LatestReceiptInfo]
//        public typealias LatestReceiptInfo = Application.AppStore.LatestReceiptInfo
//
//        /**
//         In the JSON file, an array where each element contains the pending renewal information for each auto-renewable subscription identified by the product_id. Only returned for app receipts that contain auto-renewable subscriptions.
//         */
//        public let pendingRenewalInfo: [PendingRenewalInfo]
//        public typealias PendingRenewalInfo = Application.AppStore.PendingRenewalInfo
//
//        /// A JSON representation of the receipt that was sent for verification.
//        public let receipt: Receipt?
//
//        /// Either 0 if the receipt is valid, or a status code if there is an error. The status code reflects the status of the app receipt as a whole.
//        public let status: Status
//
//        init(_ body: InternalResponseBody) {
//            environment = Environment(rawValue: body.environment ?? "")
//            isRetryable = body.isRetryable ?? false
//            latestReceipt = body.latestReceipt ?? ""
//            latestReceiptInfo = body.latestReceiptInfo?.compactMap { LatestReceiptInfo($0) } ?? []
//            pendingRenewalInfo = body.pendingRenewalInfo?.compactMap { PendingRenewalInfo($0) } ?? []
//            receipt = Receipt(body.receipt)
//            status = Status(rawValue: body.status) ?? .unknown
//        }
//
//        public struct Receipt: Content, ReceiptRepresentable {
//
//            public let adamID: Int?
//            public let appItemID: Int?
//            public let applicationVersion: String?
//            public let bundleID: String?
//            public let downloadID: Int?
//            public let expirationDate: Date?
//            public let inApp: [InApp]?
//            public let originalApplicationVersion: String?
//            public let originalPurchaseDate: Date?
//            public let preorderDate: Date?
//            public let receiptCreationDate: Date?
//            public let receiptType: ReceiptType?
//            public let requestDate: Date?
//            public let versionExternalIdentifier: Int?
//
//            init?(_ receipt: InternalResponseBody.Receipt?) {
//                guard let receipt = receipt else { return nil }
//                adamID = receipt.adamID
//                appItemID = receipt.appItemID
//                applicationVersion = receipt.applicationVersion
//                bundleID = receipt.bundleID
//                downloadID = receipt.downloadID
//                expirationDate = Date(milliseconds: receipt.expirationDateMilliseconds)
//                inApp = receipt.inApp?.compactMap { InApp($0) }
//                originalApplicationVersion = receipt.originalApplicationVersion
//                originalPurchaseDate = Date(milliseconds: receipt.originalPurchaseDateMilliseconds)
//                preorderDate = Date(milliseconds: receipt.preorderDateMilliseconds)
//                receiptCreationDate = Date(milliseconds: receipt.receiptCreationDate)
//                receiptType = ReceiptType(rawValue: receipt.receiptType ?? "")
//                requestDate = Date(milliseconds: receipt.requestDateMilliseconds)
//                versionExternalIdentifier = receipt.versionExternalIdentifier
//            }
//
//            public struct InApp: Content, InAppRepresentable {
//
//                public let cancellationDate: Date?
//                public let cancellationReason: CancellationReason?
//                public let expiresDate: Date?
//                public let isInIntroOfferPeriod: Bool?
//                public let isTrialPeriod: Bool?
//                public let originalPurchaseDate: Date?
//                public let originalTransactionID: String?
//                public let productID: String?
//                public let promotionalOfferID: String?
//                public let purchaseDate: Date?
//                public let quantity: Int?
//                public let transactionID: String?
//                public let webOrderLineItemID: String?
//
//                init?(_ inApp: InternalResponseBody.Receipt.InApp?) {
//                    guard let inApp = inApp else { return nil }
//                    cancellationDate = Date(milliseconds: inApp.cancellationDateMilliseconds)
//                    cancellationReason = CancellationReason(rawValue: inApp.cancellationReason ?? "")
//                    expiresDate = Date(milliseconds: inApp.expiresDateMilliseconds)
//                    isInIntroOfferPeriod = inApp.isInIntroOfferPeriod?.bool
//                    isTrialPeriod = inApp.isTrialPeriod?.bool
//                    originalPurchaseDate = Date(milliseconds: inApp.originalPurchaseDate)
//                    originalTransactionID = inApp.originalTransactionID
//                    productID = inApp.productID
//                    promotionalOfferID = inApp.promotionalOfferID
//                    purchaseDate = Date(milliseconds: inApp.purchaseDate)
//                    quantity = inApp.quantity?.int
//                    transactionID = inApp.transactionID
//                    webOrderLineItemID = inApp.webOrderLineItemID
//                }
//            }
//        }
//
//        public enum Status: Int, Codable, CustomStringConvertible {
//            case unknown = -1
//            case valid = 0
//            case incorrectRequestMethod = 21000
//            case malformedReceiptData = 21002
//            case authenticationError = 21003
//            case sharedSecretError = 21004
//            case unableToProvideReceipt = 21005
//            case subscriptionExpired = 21006
//            case receiptFromTestEnvironment = 21007
//            case receiptFromProductionEnvironment = 21008
//            case internalError = 21009
//            case accountError = 21010
//
//            public var errorCode: Int { rawValue }
//
//            public var message: String {
//                switch self {
//                case .unknown:
//                    return "The response did not include a status."
//                case .valid:
//                    return "The request was valid."
//                case .incorrectRequestMethod:
//                    return "The request to the App Store was not made using the HTTP POST request method."
//                case .malformedReceiptData:
//                    return "The data in the receipt-data property was malformed or the service experienced a temporary issue. Try again."
//                case .authenticationError:
//                    return "The receipt could not be authenticated."
//                case .sharedSecretError:
//                    return "The shared secret you provided does not match the shared secret on file for your account."
//                case .unableToProvideReceipt:
//                    return "The receipt server was temporarily unable to provide the receipt. Try again."
//                case .subscriptionExpired:
//                    return "This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response. Only returned for iOS 6-style transaction receipts for auto-renewable subscriptions."
//                case .receiptFromTestEnvironment:
//                    return "This receipt is from the test environment, but it was sent to the production environment for verification."
//                case .receiptFromProductionEnvironment:
//                    return "This receipt is from the production environment, but it was sent to the test environment for verification."
//                case .internalError:
//                    return "Internal data access error. Try again later."
//                case .accountError:
//                    return "The user account cannot be found or has been deleted."
//                }
//            }
//
//            public var description: String { "[\(errorCode)] \(message)" }
//
//            public var tryAgain: Bool {
//                switch self {
//                case .unknown: return false
//                case .valid: return false
//                case .incorrectRequestMethod: return false
//                case .malformedReceiptData: return true
//                case .authenticationError: return false
//                case .sharedSecretError: return false
//                case .unableToProvideReceipt: return true
//                case .subscriptionExpired: return false
//                case .receiptFromTestEnvironment: return false
//                case .receiptFromProductionEnvironment: return false
//                case .internalError: return true
//                case .accountError: return false
//                }
//            }
//        }
//    }
//
//    // MARK: - InternalResponseBody
//    struct InternalResponseBody: Content, PrettyPrintable {
//
//        enum CodingKeys: String, CodingKey {
//            case environment
//            case isRetryable = "is-retryable"
//            case latestReceipt = "latest_receipt"
//            case latestReceiptInfo = "latest_receipt_info"
//            case pendingRenewalInfo = "pending_renewal_info"
//            case receipt
//            case status
//        }
//
//        let environment: String?
//        let isRetryable: Bool?
//        let latestReceipt: String?
//        let latestReceiptInfo: [Application.AppStore.InternalLatestReceiptInfo]?
//        let pendingRenewalInfo: [Application.AppStore.InternalPendingRenewalInfo]?
//        let receipt: Receipt?
//        let status: Int
//
//        struct Receipt: Content {
//
//            enum CodingKeys: String, CodingKey {
//                case adamID = "adam_id"
//                case appItemID = "app_item_id"
//                case applicationVersion = "application_version"
//                case bundleID = "bundle_id"
//                case downloadID = "download_id"
//                case expirationDate = "expiration_date"
//                case expirationDateMilliseconds = "expiration_date_ms"
//                case expirationDatePST = "expiration_date_pst"
//                case inApp = "in_app"
//                case originalApplicationVersion = "original_application_version"
//                case originalPurchaseDate = "original_purchase_date"
//                case originalPurchaseDateMilliseconds = "original_purchase_date_ms"
//                case originalPurchaseDatePST = "original_purchase_date_pst"
//                case preorderDate = "preorder_date"
//                case preorderDateMilliseconds = "preorder_date_ms"
//                case preorderDatePST = "preorder_date_pst"
//                case receiptCreationDate = "receipt_creation_date"
//                case receiptCreationDateMilliseconds = "receipt_creation_date_ms"
//                case receiptCreationDatePST = "receipt_creation_date_pst"
//                case receiptType = "receipt_type"
//                case requestDate = "request_date"
//                case requestDateMilliseconds = "request_date_ms"
//                case requestDatePST = "request_date_pst"
//                case versionExternalIdentifier = "version_external_identifier"
//            }
//
//            let adamID: Int?
//            let appItemID: Int?
//            let applicationVersion: String?
//            let bundleID: String?
//            let downloadID: Int?
//            let expirationDate: String?
//            let expirationDateMilliseconds: String?
//            let expirationDatePST: String?
//            let inApp: [InApp]?
//            let originalApplicationVersion: String?
//            let originalPurchaseDate: String?
//            let originalPurchaseDateMilliseconds: String?
//            let originalPurchaseDatePST: String?
//            let preorderDate: String?
//            let preorderDateMilliseconds: String?
//            let preorderDatePST: String?
//            let receiptCreationDate: String?
//            let receiptCreationDateMilliseconds: String?
//            let receiptCreationDatePST: String?
//            let receiptType: String?
//            let requestDate: String?
//            let requestDateMilliseconds: String?
//            let requestDatePST: String?
//            let versionExternalIdentifier: Int?
//
//            struct InApp: Content {
//
//                enum CodingKeys: String, CodingKey {
//                    case cancellationDate = "cancellation_date"
//                    case cancellationDateMilliseconds = "cancellation_date_ms"
//                    case cancellationDatePST = "cancellation_date_pst"
//                    case cancellationReason = "cancellation_reason"
//                    case expiresDate = "expires_date"
//                    case expiresDateMilliseconds = "expires_date_ms"
//                    case expiresDatePST = "expires_date_pst"
//                    case isInIntroOfferPeriod = "is_in_intro_offer_period"
//                    case isTrialPeriod = "is_trial_period"
//                    case originalPurchaseDate = "original_purchase_date"
//                    case originalPurchaseDateMilliseconds = "original_purchase_date_ms"
//                    case originalPurchaseDatePST = "original_purchase_date_pst"
//                    case originalTransactionID = "original_transaction_id"
//                    case productID = "product_id"
//                    case promotionalOfferID = "promotional_offer_id"
//                    case purchaseDate = "purchase_date"
//                    case purchaseDateMilliseconds = "purchase_date_ms"
//                    case purchaseDatePST = "purchase_date_pst"
//                    case quantity
//                    case transactionID = "transaction_id"
//                    case webOrderLineItemID = "web_order_line_item_id"
//                }
//
//                let cancellationDate: String?
//                let cancellationDateMilliseconds: String?
//                let cancellationDatePST: String?
//                let cancellationReason: String?
//                let expiresDate: String?
//                let expiresDateMilliseconds: String?
//                let expiresDatePST: String?
//                let isInIntroOfferPeriod: String?
//                let isTrialPeriod: String?
//                let originalPurchaseDate: String?
//                let originalPurchaseDateMilliseconds: String?
//                let originalPurchaseDatePST: String?
//                let originalTransactionID: String?
//                let productID: String?
//                let promotionalOfferID: String?
//                let purchaseDate: String?
//                let purchaseDateMilliseconds: String?
//                let purchaseDatePST: String?
//                let quantity: String?
//                let transactionID: String?
//                let webOrderLineItemID: String?
//            }
//        }
//    }
//}
