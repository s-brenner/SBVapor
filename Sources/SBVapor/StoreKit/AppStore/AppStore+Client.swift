import Vapor

public extension Application.AppStore {
    
    struct Client {
        
        let httpClient: HTTPClient
        
        let password: String
        
        enum Endpoint: String {
            case production = "https://buy.itunes.apple.com/verifyReceipt"
            case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
            
            var url: URL { URL(string: rawValue)! }
        }
    }
}

public extension Application.AppStore.Client {

    func verifyReceipt(
        receiptData: Data,
        excludeOldTransactions: Bool? = nil,
        on req: Request
    ) -> EventLoopFuture<AppStoreReceipts.ResponseBody> {
        let body = AppStoreReceipts.RequestBody(
            receiptData: receiptData,
            password: password,
            excludeOldTransactions: excludeOldTransactions
        )
        return verifyReceipt(body: body, endpoint: .production, on: req)
            .flatMap { responseBody in
                guard responseBody.status != .receiptFromTestEnvironment else {
                    return verifyReceipt(body: body, endpoint: .sandbox, on: req)
                }
                return req.eventLoop.future(responseBody)
            }
    }
    
    enum Error: Swift.Error {
        case decodingError(Swift.Error)
        case passwordMismatch
    }
    
    func handleServerNotification(on req: Request) -> Result<AppStoreServerNotifications.ResponseBody, Error> {
        do {
            let internalResponseBody = try req.content.decode(AppStoreServerNotifications.InternalResponseBody.self)
            guard internalResponseBody.password == password else {
                return .failure(.passwordMismatch)
            }
            return .success(.init(internalResponseBody))
        } catch {
            return .failure(.decodingError(error))
        }
    }
}

private extension Application.AppStore.Client {
    
    func verifyReceipt(
        body: AppStoreReceipts.RequestBody,
        endpoint: Endpoint,
        on req: Request
    ) -> EventLoopFuture<AppStoreReceipts.ResponseBody> {
        do {
            let request = try HTTPClient.Request.make(with: body, url: endpoint.url)
            return httpClient.execute(request: request, eventLoop: .delegate(on: req.eventLoop))
                .flatMap { response in
                    let byteBuffer = response.body ?? ByteBuffer(.init())
                    let responseData = Data(byteBuffer.readableBytesView)
                    let responseBody = responseData
                        .decode(as: AppStoreReceipts.InternalResponseBody.self)
                        .map { AppStoreReceipts.ResponseBody($0) }
                    switch responseBody {
                    case .success(let response):
                        return req.eventLoop.future(response)
                    case .failure(let error):
                        return req.eventLoop.makeFailedFuture(error)
                    }
                }
        } catch {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
}

fileprivate extension HTTPClient.Request {
    
    static func make(
        with requestBody: AppStoreReceipts.RequestBody,
        url: URL
    ) throws -> HTTPClient.Request {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        headers.add(name: .userAgent, value: "ReservePayServer")
        let body = try JSONEncoder().encode(requestBody)
        return try HTTPClient.Request(
            url: url,
            method: .POST,
            headers: headers,
            body: .data(body)
        )
    }
}
