import Foundation

final class UsersService {

    static let shared = UsersService()
    
    func getCurrentUser(appVanityDomain: String, token: String) async throws -> User {

        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/oauth2/userinfo") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(User.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
    
}
