import Foundation
import KeychainAccess

final class KeychainService {
    
    static let shared = KeychainService()
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 format
    }
    
    func saveToken(tokenResponse: TokenResponse) {
        saveString(name: "access_token", value: tokenResponse.accessToken)
        saveString(name: "expires_in", value: String(tokenResponse.expiresIn))
        saveString(name: "refresh_token", value: tokenResponse.refreshToken)
        if let tokenExpirationDate = tokenResponse.tokenExpirationDate {
            saveDate(name: "token_expiration_date", date: tokenExpirationDate)
        }
    }
    
    func getToken() -> TokenResponse? {
        let access_token = getString(name: "access_token")
        let expires_in = getString(name: "expires_in")
        let refresh_token = getString(name: "refresh_token")
        
        if let access_token, let expires_in = expires_in, let expires_in = Int(expires_in), let refresh_token {
            let tokenExpirationDate = getDate(name: "token_expiration_date") ?? Date()
            return TokenResponse(
                accessToken: access_token,
                expiresIn: expires_in,
                refreshToken: refresh_token,
                tokenExpirationDate: tokenExpirationDate
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
            print("Error saving \(name): \(error)")
        }
    }

    func getString(name: String) -> String? {
        let keychain = Keychain(service: "iOS-Demo-App")
        return try? keychain.get(name)
    }
    
    func saveDate(name: String, date: Date) {
        let dateString = dateFormatter.string(from: date)
        saveString(name: name, value: dateString)
    }

    func getDate(name: String) -> Date? {
        guard let dateString = getString(name: name) else {
            return nil
        }
        return dateFormatter.date(from: dateString)
    }
}
