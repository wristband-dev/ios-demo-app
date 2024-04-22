import Foundation

struct User: Decodable, Equatable {
    let email: String
    let givenName: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case givenName = "given_name"
    }
}
