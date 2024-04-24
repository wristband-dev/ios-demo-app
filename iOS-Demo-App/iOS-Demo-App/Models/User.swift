import Foundation

struct User: Decodable, Equatable, Identifiable {
    let email: String
    let givenName: String?
    let id: String
    let status: String?
    let tenantId: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case givenName = "given_name"
        case id = "app_id"
        case status = "status"
        case tenantId = "tenant_id"
    }
}

