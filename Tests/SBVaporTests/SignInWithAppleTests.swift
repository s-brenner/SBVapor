import XCTVapor
@testable import SBVapor
import XCTest

final class SignInWithAppleTests: XCTestCase {
    
    func testSignIn() async {
        let app = Application(.testing)
        defer { app.shutdown() }
        let userIdentifier = "001378.61d5a8f9a867409eb57cd72090989ed0.0212"
        let authorizationCode = "c97a7b2d93e5342b69368138fe1eeb353.0.srtxy.YTv9VC1CV7WeVXynKDn23A"
        let identityToken = "eyJraWQiOiJXNldjT0tCIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLnNjb3R0LmJyZW5uZXIuZGV2ZWxvcGVyLkF0bGFzV2luZHMiLCJleHAiOjE2NDQ5MDAxNDcsImlhdCI6MTY0NDgxMzc0Nywic3ViIjoiMDAxMzc4LjYxZDVhOGY5YTg2NzQwOWViNTdjZDcyMDkwOTg5ZWQwLjAyMTIiLCJjX2hhc2giOiJ1U3FZNEpRbm5OQnRQb0FUMGc1VHN3IiwiZW1haWwiOiI4bmczeGljMnZrQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjoidHJ1ZSIsImlzX3ByaXZhdGVfZW1haWwiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjQ0ODEzNzQ3LCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.HEXgkbqny0P4OV6sH-48r_ubUmDNL7P9FnIfvfcLP6dAAJYocb6ziwxt5-tMHdPVcVEll8Bh1Jzq34vCMPMt_PRzA8l8XfwtfBdwtmetloK36MJjSJqvhKl06eZ9c1neN7qeaY9VEdVdC7xSaXORKadPJGS6mgI6wG7ceHfDTdf1eeTtF7RMQPYzPGZhJv0xxKxIhu-FyQzPsISyAWg9D_oKwey3twNpR0zN8eg_ykKD8757mZ1AvPx3r-MpeorgqcRJHzSqnAdw7WINbmza0sJPE_Pqg7yXi3mCzcvFB9I30Z_FYYpasfg-ZnLNiR_jp7asM3eCNa1pwb9hao1emw"
        do {
            try app.register(collection: SignInWithAppleController())
            try app.testable().test(.POST, "siwa/sign_in", headers: .init(), body: nil) { req in
                let unverifiedCredential = Application.SignInWithApple.UnverifiedCredential(
                    userIdentifier: userIdentifier,
                    authorizationCode: authorizationCode,
                    identityToken: identityToken
                )
                try req.content.encode(unverifiedCredential)
            } afterResponse: { res in
                do {
                    let credential = try res.content.decode(Application.SignInWithApple.AuthorizedCredential.self)
                    print(credential)
                }
                catch {
                    guard let vaporError = try? res.content.decode(VaporError.self) else {
                        throw error
                    }
                    XCTFail(vaporError.reason)
                }
            }
        }
        catch {
            print(error)
            XCTFail()
        }
    }
    
    func testValidateRefreshToken() async {
        let app = Application(.testing)
        defer { app.shutdown() }
        let refreshToken = "re325657d6c124cefbc94afb2c844eb23.0.srtxy.fw48n2cz441r-k1VyBlkSg"
        do {
            try app.register(collection: SignInWithAppleController())
            try app.testable().test(.POST, "siwa/validate", headers: .init(), body: nil) { req in
                try req.content.encode(refreshToken)
            } afterResponse: { res in
                do {
                    let credential = try res.content.decode(Application.SignInWithApple.AuthorizedCredential.self)
                    print(credential)
                }
                catch {
                    guard let vaporError = try? res.content.decode(VaporError.self) else {
                        throw error
                    }
                    XCTFail(vaporError.reason)
                }
            }
        }
        catch {
            print(error)
            XCTFail()
        }
    }
    
    fileprivate struct VaporError: Content {
        
        let reason: String
    }
}

fileprivate struct SignInWithAppleController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let siwa = routes.grouped("siwa")
        siwa.post("sign_in", use: signIn)
        siwa.post("validate", use: validate)
    }
    
    private func signIn(on req: Request) async throws -> Application.SignInWithApple.AuthorizedCredential {
        let credential = try req.content.decode(Application.SignInWithApple.UnverifiedCredential.self)
        return try await req.application.signInWithApple.client.signIn(with: credential, on: req)
    }
    
    private func validate(on req: Request) async throws -> Application.SignInWithApple.AuthorizedCredential {
        let value = try req.content.decode(String.self)
        let refreshToken = Application.SignInWithApple.RefreshToken(value: value, validationDate: nil)!
        return try await req.application.signInWithApple.client.validateRefreshToken(refreshToken, on: req)
    }
}
