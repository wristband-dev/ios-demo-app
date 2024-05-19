import Foundation

struct InviteUserBody: Encodable {
    var tenantId: String
    var appId: String
    var email: String
    var rolesToBeAssign: [String]
}
