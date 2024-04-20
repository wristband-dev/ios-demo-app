import Foundation
import KeychainAccess

final class KeychainService {
    
    static let shared = KeychainService()
    
    func saveToken(token: String) {
        let keychain = Keychain(service: "donato.com.iOS-Demo-App")
        do {
            try keychain.set(token, key: "authToken")
        } catch let error {
            print("Error saving token: \(error)")
        }
    }

    func getToken() -> String? {
        let keychain = Keychain(service: "donato.com.iOS-Demo-App")
        return try? keychain.get("authToken")
    }
}
