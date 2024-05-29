import Foundation

struct Invoice: Codable, Identifiable, Equatable {
    var id: UUID
    var companyName: String
    var description: String
    var amount: Double
}
