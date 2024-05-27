import Foundation

struct User: Decodable, Equatable, Identifiable, Encodable {
    var id: String
    var appId: String?
    var email: String
    var emailVerified: Bool
    var givenName: String?
    var familyName: String?
    var middleName: String?
    var nickname: String?
    var pictureUrl: String?
    var gender: String?
    var birthdate: String?
    var locale: String?
    var timezone: String?
    var phoneNumber: String?
    var identityProviderName: String?
    var tenantId: String?
    var updatedAt: Int?
    var roles: [Role]?

    enum CodingKeys: String, CodingKey {
        case id = "sub"
        case appId = "app_id"
        case email
        case emailVerified = "email_verified"
        case givenName = "given_name"
        case familyName = "family_name"
        case middleName = "middle_name"
        case nickname
        case pictureUrl = "picture"
        case phoneNumber = "phone_number"
        case gender
        case birthdate
        case locale
        case timezone = "zoneinfo"
        case identityProviderName = "idp_name"
        case tenantId = "tnt_id"
        case updatedAt = "updated_at"
        case roles
    }
}

struct Role: Decodable, Equatable, Identifiable, Encodable {
    var id: String
    var name: String
    var displayName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case displayName
    }
}
