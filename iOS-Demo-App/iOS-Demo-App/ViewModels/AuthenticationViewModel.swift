import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    @Published var showBrowser = true
    
    @Published var appName: String?
    @Published var appVanityDomain: String?
    @Published var clientId: String?
    @Published var tenantDomainName: String?
    
    @Published var tokenResponse: TokenResponse? = nil
    
    init() {
        self.appName = Bundle.main.infoDictionary?["APP_NAME"] as? String
        self.appVanityDomain = Bundle.main.infoDictionary?["APPLICATION_VANITY_DOMAIN"] as? String
        self.clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String
        self.tenantDomainName = Bundle.main.infoDictionary?["TENANT_DOMAIN_NAME"] as? String
    }
    
    func handleRedirectUri(url: URL) async {
        
        guard url.scheme == self.appName, url.host == "callback" else {
            return
        }
        
        // get components from url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // get auth code from url
        if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value,
           let appName, let appVanityDomain, let clientId {
            do {
                // get token
                self.tokenResponse = try await AuthenticationService.shared.getToken(appName: appName, appVanityDomain: appVanityDomain, authCode: code, clientId: clientId)
                print(tokenResponse)
                // close browser
                self.showBrowser = false
            } catch {
                print("Unable to get token: \(error)")
            }
        }
    }
}
