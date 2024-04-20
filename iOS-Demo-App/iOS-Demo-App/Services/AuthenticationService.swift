//import Foundation
//
//final class AuthenticationService {
//    
//    static let shared = AuthenticationService()
//    
//    func getToken(appName: String, appVanityDomain: String, authCode: String, clientId: String) async throws {
//        
//        let headers = [
//            "Content-Type": "application/x-www-form-urlencoded",
//            "Accept": "application/json"
//        ]
//        
//        let postData = NSMutableData(data: "grant_type=authorization_code".data(using: String.Encoding.utf8)!)
//        postData.append("&client_id=\(clientId)".data(using: String.Encoding.utf8)!)
//        postData.append("&code_verifier=\("ODcShN2BljONyCz6o_AvQYSC8wBw5jEbTPDaCcc9XNc")".data(using: String.Encoding.utf8)!)
//        postData.append("&code=\(authCode)".data(using: String.Encoding.utf8)!)
//        postData.append("&redirect_uri=\(appName)%3A%2F%2Fcallback".data(using: String.Encoding.utf8)!)
//        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://\(appVanityDomain)/api/v1/oauth2/token")! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = postData as Data
//        
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            let httpResponse = response as? HTTPURLResponse
//            if httpResponse?.statusCode != 200, let data {
//                let result = try JSONDecoder().decode(TokenResponse.self, from: data)
//                print(result)
//            }
//        })
//        
//        dataTask.resume()
//    }
//}
//

import Foundation

// Assuming `model` is `TokenResponse` and you have defined it somewhere else.
final class AuthenticationService {

    static let shared = AuthenticationService()
    
    func getToken(appName: String, appVanityDomain: String, authCode: String, clientId: String) async throws -> TokenResponse {

        guard let url = URL(string: "https://\(appVanityDomain)/api/v1/oauth2/token") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = "grant_type=authorization_code&client_id=\(clientId)&code_verifier=ODcShN2BljONyCz6o_AvQYSC8wBw5jEbTPDaCcc9XNc&code=\(authCode)&redirect_uri=\(appName)%3A%2F%2Fcallback"
        
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
}
