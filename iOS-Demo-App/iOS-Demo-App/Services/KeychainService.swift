import Foundation
import KeychainAccess

final class KeychainService {
    
    static let shared = KeychainService()
    
    func saveToken(tokenResponse: TokenResponse) {
        saveString(name: "access_token", value: tokenResponse.accessToken)
        saveString(name: "expires_in", value: String(tokenResponse.expiresIn))
        saveString(name: "refresh_token", value: tokenResponse.refreshToken)
        
    }
    
    func getToken() -> TokenResponse? {
        let access_token = getString(name: "access_token")
        let expires_in = getString(name: "expires_in")
        let refresh_token = getString(name: "refresh_token")
        if let access_token, let expires_in, let expires_in = Int(expires_in), let refresh_token {
            return TokenResponse(
                accessToken: access_token,
                expiresIn: expires_in,
                refreshToken: refresh_token
            )
        } else {
            return nil
        }
    }
    
    func saveString(name: String, value: String) {
        let keychain = Keychain(service: "iOS-Demo-App")
        do {
            try keychain.set(value, key: name)
        } catch let error {
            print("Error saving token: \(error)")
        }
    }

    func getString(name: String) -> String? {
        let keychain = Keychain(service: "iOS-Demo-App")
        return try? keychain.get(name)
    }
}
