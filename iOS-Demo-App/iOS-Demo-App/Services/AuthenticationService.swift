import Foundation

//class AuthService {
//
//    func login() async throws {
//        // hard coded to customer 1 tenant
//        let authEndPoint = "https://customer1.iosdemoapp-donato.us.wristband.dev/api/v1/oauth2/authorize"
//        
//        
//        // 1. Create url
//        guard let url = URL(string: "https://customer1.us.wristband.dev/api/v1/oauth2/authorize?client_id=mlnp6h6nwrdd3ptqfvsi6pbieu&response_type=code&redirect_uri=https%3A%2F%2Fdemo.com&state=jcm2ejayovsgbgbpkihblu47&nonce=gbgbpkihblu47jcm2ejayovs&scope=openid+offline_access&code_challenge=v8Bh0vp3j9dbGNeotHaJDUDHl0bS8aNk2OMeiSLBoc4&code_challenge_method=S256") else {
//            fatalError("Invalid URL")
//        }
//        
//        var request = URLRequest(url: url)
//        
//        // 3. Send request
//        do {
//            let
//            (data, _) = try await URLSession.shared.data(for: request)
//            
//            // 4. Parse the JSON
//            let decoder = JSONDecoder()
//            print(data)
//            
//            
//        }
//        catch {
//            print(error)
//        }
//    }
//}
