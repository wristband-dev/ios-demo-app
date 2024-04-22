import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    // Authentication view state
    @Published var showAuthenticationView = true
    @Published var errorMsg: String?
    
    // Info.plsy
    @Published var appName: String?
    @Published var appVanityDomain: String?
    @Published var clientId: String?
    
    // Login Browser
    @Published var showLoginBrowser = true
    @Published var tenantDomainName: String?
    @Published var loginHint: String?
    
    // PKCE
    @Published var codeVerifier: String?
    @Published var codeChallenge: String?
    
    // Response Token
    @Published var tokenResponse: TokenResponse? = nil
    @Published var tokenExpirationDate: Date? = nil
    
    init() {
        getInfoDictValues()
        
//        startUp()
    }
    
    
    var isUserAuthenticated: Bool {
        return tokenResponse != nil ? true : false
    }
    
    var isTokenExpired: Bool {
        guard let tokenResponse = tokenResponse else { return true }
        guard let tokenExpirationDate = tokenResponse.tokenExpirationDate else { return true }
        
        return tokenExpirationDate >= Date()
    }
    
    func getInfoDictValues() {
        self.appName = Bundle.main.infoDictionary?["APP_NAME"] as? String
        self.appVanityDomain = Bundle.main.infoDictionary?["APPLICATION_VANITY_DOMAIN"] as? String
        self.clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String
    }
    
    func handleRedirectUri(url: URL) async {
        
        guard url.scheme == self.appName else {
            return
        }
        
        // get components from url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if url.host == "login" {
            
            // get tenant_domain
            if let tenantDomain = components?.queryItems?.first(where: { $0.name == "tenant_domain" })?.value,
               let loginHint = components?.queryItems?.first(where: { $0.name == "login_hint" })?.value {
                
                self.tenantDomainName = tenantDomain
                self.loginHint = loginHint
                generatePKCE()
            }
            
        } else if url.host == "callback" {
            
            // get code
            if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
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
                print(tokenResponse)
                
                // save token to keychain
                if let tokenResponse {
                    KeychainService.shared.saveToken(tokenResponse: tokenResponse)
                }

                if let expiresIn = tokenResponse?.expiresIn {
                    self.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                }

                // proceed to content view
                self.showLoginBrowser = false
                self.showAuthenticationView = false
                
            } catch {
                self.showLoginBrowser = false
                self.errorMsg = "Unable to login, please reach out for support"
                print("Unable to get token: \(error)")
            }
        }
    }
    
    func refreshToken() {
        
    }
    
    func generatePKCE() {
        self.codeVerifier = PKCEGeneratorService.shared.generateCodeVerifier()
        if let codeVerifier {
            self.codeChallenge = PKCEGeneratorService.shared.generateCodeChallenge(from: codeVerifier)
        }
    }
}
