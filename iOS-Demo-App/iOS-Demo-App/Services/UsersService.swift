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
    
    func getUsers(appId: String, appVanityDomain: String, token: String, start_index: Int, count: Int) async throws -> User {

        // Construct the URL with query parameters
        let urlString = "https://\(appVanityDomain)/api/v1/applications/\(appId)/users?count=\(count)&start_index=\(start_index)&fields=givenName,familyName,email,status,tenantId"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Perform the GET request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Check for successful status code
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode JSON response
        do {
            let decodedResponse = try JSONDecoder().decode(User.self, from: data)
            return decodedResponse
        } catch {
            throw URLError(.cannotWriteToFile)
        }
    }
}
