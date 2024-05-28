import Foundation

//        encoder.outputFormatting = .prettyPrinted // This helps in making the JSON output more readable
//
//        do {
//            let postData = try encoder.encode(user)
//            request.httpBody = postData
//
//            // Convert postData back to a String to print it
//            if let jsonString = String(data: postData, encoding: .utf8) {
//                print("Encoded JSON string:")
//                print(jsonString)
//            }
//        } catch {
//            print("Error encoding data: \(error)")
//        }


//        decodeAndPrintJson(data: data)
//        print(response)

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
    
    func updateCurrentUser(appVanityDomain: String, token: String, user: UpdateUserBody) async throws {
        
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/users/\(user.id)?replace_custom_metadata=true") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let postData = try encoder.encode(user)
        request.httpBody = postData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    func changePassword(appVanityDomain: String, token: String, changePasswordBody: ChangePasswordBody) async throws {
        
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/change-password") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let postData = try encoder.encode(changePasswordBody)
        request.httpBody = postData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    func changeEmail(appVanityDomain: String, token: String, changeEmailBody: ChangeEmailBody) async throws {
        
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/change-email/request-email-change") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let postData = try encoder.encode(changeEmailBody)
        request.httpBody = postData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    
//    func getUsers(appId: String, appVanityDomain: String, token: String, start_index: Int, count: Int) async throws -> User {
//
//        // Construct the URL with query parameters
//        let urlString = "https://\(appVanityDomain)/api/v1/applications/\(appId)/users?count=\(count)&start_index=\(start_index)&fields=givenName,familyName,email,status,tenantId"
//        
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        // Perform the GET request
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//        
//        // Check for successful status code
//        guard httpResponse.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//        
//        // Decode JSON response
//        do {
//            let decodedResponse = try JSONDecoder().decode(User.self, from: data)
//            return decodedResponse
//        } catch {
//            throw URLError(.cannotWriteToFile)
//        }
//    }
    
    func inviteNewUser(appVanityDomain: String, token: String, inviteUserBody: InviteUserBody) async throws {

        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/new-user-invitation/invite-user") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let postData = try encoder.encode(inviteUserBody)
        request.httpBody = postData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getRoles(appVanityDomain: String, token: String, tenantId: String) async throws -> Roles {
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/tenants/\(tenantId)/roles?include_application_roles=true&fields=id,name,displayName&sort_by=displayName:asc") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(Roles.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
    
    func getUserInvites(appVanityDomain: String, token: String, tenantId: String) async throws -> [PendingInvite] {
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/tenants/\(tenantId)/new-user-invitation-requests?sort_by=email&count=50&query=status eq \"PENDING_INVITE_ACCEPTANCE\"") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(PendingInvites.self, from: data)
            return decodedResponse.items
        } catch {
            throw error
        }
    }
    
    func cancelUserInvite(appVanityDomain: String, token: String, cancelUserInviteBody: CancelUserInviteBody) async throws{
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/new-user-invitation/cancel-invite") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let postData = try encoder.encode(cancelUserInviteBody)
        request.httpBody = postData

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
}
