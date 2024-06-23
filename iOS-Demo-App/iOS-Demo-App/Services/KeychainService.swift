import Foundation
import KeychainAccess

final class KeychainService {
    
    static let shared = KeychainService()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" 
        return formatter
    }()
    
    private let keychain = Keychain(service: "iOS-Demo-App")

    func saveToken(tokenResponse: TokenResponse) {
        do {
            try keychain.set(tokenResponse.accessToken, key: "access_token")
            try keychain.set(String(tokenResponse.expiresIn), key: "expires_in")
            try keychain.set(tokenResponse.refreshToken, key: "refresh_token")
            if let tokenExpirationDate = tokenResponse.tokenExpirationDate {
                let dateString = dateFormatter.string(from: tokenExpirationDate)
                try keychain.set(dateString, key: "token_expiration_date")
            }
        } catch let error {
            print("Error saving token data: \(error)")
        }
    }
    
    func getToken() async -> TokenResponse? {
        do {
            if let accessToken = try keychain.get("access_token"),
               let expiresInString = try keychain.get("expires_in"),
               let expiresIn = Int(expiresInString),
               let refreshToken = try keychain.get("refresh_token") {
                let tokenExpirationDate = dateFormatter.date(from: try keychain.get("token_expiration_date") ?? "") ?? Date()
                return TokenResponse(accessToken: accessToken, expiresIn: expiresIn, refreshToken: refreshToken, tokenExpirationDate: tokenExpirationDate)
            }
        } catch let error {
            print("Error retrieving token: \(error)")
        }
        return nil
    }
    
    func deleteToken() {
        ["access_token", "expires_in", "refresh_token", "token_expiration_date"].forEach {
            do {
                try keychain.remove($0)
            } catch let error {
                print("Error removing \($0): \(error)")
            }
        }
    }
    
    func saveTenantDomainName(tenantDomainName: String) {
        do {
            try keychain.set(tenantDomainName, key: "tenant_domain_name")
        } catch let error {
            print("Error saving tenant domain name: \(error)")
        }
    }
    
    func getTenantDomainName() async -> String? {
        do {
            if let tenantDomainName = try keychain.get("tenant_domain_name") {
                return tenantDomainName
            }
        } catch let error {
            print("Error saving tenant domain name: \(error)")
        }
        return nil
    }
    
    func deleteTenantDomainName() {
        do {
            try keychain.remove("tenant_domain_name")
        } catch let error {
            print("Error removing tenant domain name: \(error)")
        }
    }
    
}
