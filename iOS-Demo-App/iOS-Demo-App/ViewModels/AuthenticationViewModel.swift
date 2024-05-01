import Foundation
import SwiftUI

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    // Authentication view state
    @Published var isLoading = true
    @Published var path = NavigationPath()
    @Published var errorMsg: String?
    
    // Info.plsy
    @Published var appName: String?
    @Published var appId: String?
    @Published var appVanityDomain: String?
    @Published var clientId: String?
    
    // Login Browser
    @Published var showLoginBrowser = false
    @Published var tenantDomainName: String?
    @Published var loginHint: String?
    
    // Logout Browser
    @Published var showLogOutBrowser = false
    
    // PKCE
    @Published var codeVerifier: String?
    @Published var codeChallenge: String?
    
    // Response Token
    @Published var tokenResponse: TokenResponse? = nil
    
    var isUserAuthenticated: Bool {
        return tokenResponse != nil ? true : false
    }

    init() {
        getInfoDictValues()
    }
    
    
    func getInfoDictValues() {
        self.appName = Bundle.main.infoDictionary?["APP_NAME"] as? String
        self.appId = Bundle.main.infoDictionary?["APP_ID"] as? String
        self.appVanityDomain = Bundle.main.infoDictionary?["APPLICATION_VANITY_DOMAIN"] as? String
        self.clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String
    }
    
    
    func getStoredToken() async {
        self.tokenResponse = await KeychainService.shared.getToken()
        
        _ = await getToken()
        
        self.isLoading = false
    }
    
    
    func getToken() async -> String? {
        // if no token return nil and show auth
        guard let tokenResponse else {
            return nil
        }
        
        // if token is not expired return access token
        guard tokenResponse.isTokenExpired else {
            return tokenResponse.accessToken
        }
            
        // if token expired, attempt to refresh token
        do {
            try await refreshToken(refreshToken: tokenResponse.refreshToken)
            return self.tokenResponse?.accessToken
            
        // unable to refresh return nil and show auth screen
        } catch {
            return nil
        }
    }
    
    
    func handleRedirectUri(url: URL) async {
        
        guard url.scheme == self.appName else {
            return
        }

        // get components from url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if url.host == "login" {
            
            // get tenant_domain
            if let tenantDomain = components?.queryItems?.first(where: { $0.name == "tenant_domain" })?.value {
                
                // get info from login
                self.tenantDomainName = tenantDomain
                
                // clear cached token
                self.tokenResponse = nil
                
                // clear stored token
                KeychainService.shared.deleteToken()
                
                // return to main path
                self.path.removeLast(self.path.count)
                
                // close logout browser
                self.showLogOutBrowser = false
                
                // generate pkce for tenant login
                generatePKCE()
            }
            
            if let loginHint = components?.queryItems?.first(where: { $0.name == "login_hint" })?.value {
                
                self.loginHint = loginHint
            }
            
        } else if url.host == "callback" {
            
            // get code
            if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                
                // verify state is the same as the one sent out
                
                await createToken(code: code)
            }
        }
        
    }
    
    
    func createToken(code: String) async {
        if let appName, let appVanityDomain, let clientId, let codeVerifier {
            
            do {
                // get token
                self.tokenResponse = try await AuthenticationService.shared.getToken(appName: appName, appVanityDomain: appVanityDomain, authCode: code, clientId: clientId, codeVerifier: codeVerifier)
                
                // create token expiration date
                if let expiresIn = tokenResponse?.expiresIn {
                    self.tokenResponse?.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                }
                
                // save token to keychain
                if let tokenResponse {
                    KeychainService.shared.saveToken(tokenResponse: tokenResponse)
                }
                
                // proceed to content view
                self.showLoginBrowser = false
                
            } catch {
                self.showLoginBrowser = false
                self.errorMsg = "Unable to login, please reach out for support"
                print("Unable to get token: \(error)")
            }
        }
    }
    
    
    func refreshToken(refreshToken: String) async throws{
        if let appVanityDomain, let clientId {
     
            // get token
            self.tokenResponse = try await AuthenticationService.shared.getRefreshToken(appVanityDomain: appVanityDomain, clientId: clientId, refreshToken: refreshToken)
            
            // create token expiration date
            if let expiresIn = tokenResponse?.expiresIn {
                self.tokenResponse?.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
            }
            
            // save token to keychain
            if let tokenResponse {
                KeychainService.shared.saveToken(tokenResponse: tokenResponse)
            }
           
        }
    }
    
    func generatePKCE() {
        self.codeVerifier = PKCEGeneratorService.shared.generateCodeVerifier()
        if let codeVerifier {
            self.codeChallenge = PKCEGeneratorService.shared.generateCodeChallenge(from: codeVerifier)
        }
    }
    
    func generateState() {
        
    }
    
    func generateNonce() {
        
    }
    
    
    func logout() async {
        
        if let appVanityDomain, let clientId, let refreshToken =  tokenResponse?.refreshToken {
            do {
                // revoke token
                try await AuthenticationService.shared.revokeToken(appVanityDomain: appVanityDomain, clientId: clientId, refreshToken: refreshToken)
                
                // clear cookies
                self.showLogOutBrowser = true

            } catch {
                print("Unable to revoke token: \(error)")
            }
        }
    }
    
    
}
