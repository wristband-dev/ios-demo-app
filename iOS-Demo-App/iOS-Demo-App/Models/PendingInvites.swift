import Foundation

struct Metadata: Codable {
    let creationTime: String
    let version: String
    let lastModifiedTime: String
}

struct PendingInvite: Codable, Identifiable {
    let id: String
    let externalIdpDisplayName: String?
    let rolesToAssign: [String]
    let metadata: Metadata
    let expirationTime: String
    let tenantId: String
    let externalIdpRequestStatus: String
    let externalIdpName: String?
    let applicationId: String
    let email: String
    let externalIdpType: String?
    let status: String
}

struct PendingInvites: Codable {
    let itemsPerPage: Int
    let totalResults: Int
    let items: [PendingInvite]
    let startIndex: Int
}


struct CancelUserInviteBody: Encodable {
    var newUserInvitationRequestId: String
}
