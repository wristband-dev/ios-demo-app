import Foundation

final class TenantService {
    
    static let shared = TenantService()
    
    func getTenant(appVanityDomain: String, token: String, tenantId: String) async throws -> TenantPublicMetadataBody{
        
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/tenants/\(tenantId)") else {
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
            let decodedResponse = try JSONDecoder().decode(TenantPublicMetadataBody.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
    
    func patchTenant(appVanityDomain: String, token: String, tenantId: String, publicMetaDataBody: TenantPublicMetadataBody) async throws  {
        
        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/tenants/\(tenantId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("\(appVanityDomain)", forHTTPHeaderField: "Host")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let postData = try encoder.encode(publicMetaDataBody)
        request.httpBody = postData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

