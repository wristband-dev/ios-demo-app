import Foundation

struct Roles: Encodable, Decodable {
    var itemsPerPage: Int?
    var totalRestults: Int?
    var startIndex: Int?
    var items: [Role]
}
