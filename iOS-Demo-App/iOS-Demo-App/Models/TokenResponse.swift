import Foundation

struct TokenResponse: Decodable, Equatable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    var tokenExpirationDate: Date?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}
