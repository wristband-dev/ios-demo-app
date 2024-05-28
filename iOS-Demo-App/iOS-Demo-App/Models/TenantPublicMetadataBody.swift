import Foundation

struct TenantPublicMetadataBody: Encodable, Decodable {
    var publicMetadata: Company
}

struct Company: Encodable, Decodable {
    var companyName: String?
    var companyAddress: String?
    var companyCity: String?
    var companyZipCode: String?
    var companyState: String?
}
