import Foundation

struct InviteUserBody: Encodable {
    var tenantId: String
    var email: String
    var rolesToBeAssign: [String]
}
