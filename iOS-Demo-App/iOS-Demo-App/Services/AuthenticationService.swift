import Foundation

final class AuthenticationService {

    static let shared = AuthenticationService()
    
    
    func getToken(appName: String, appVanityDomain: String, authCode: String, clientId: String, codeVerifier: String) async throws -> TokenResponse {

        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/oauth2/token") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = "grant_type=authorization_code&client_id=\(clientId)&code_verifier=\(codeVerifier)&code=\(authCode)&redirect_uri=\(appName)%3A%2F%2Fcallback"
        
        request.httpBody = postString.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
    
    
    func getRefreshToken(appVanityDomain: String, clientId: String, refreshToken: String) async throws -> TokenResponse {

        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/oauth2/token") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = "grant_type=refresh_token&client_id=\(clientId)&refresh_token=\(refreshToken)"
        
        request.httpBody = postString.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
    
    
    func logout(appVanityDomain: String) async throws {
        
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/logout") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    
}
