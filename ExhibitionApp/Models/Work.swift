import Foundation

struct Work: Codable {
    let id: Int
    let title: String
    let resource: String
    let authors: [String]
    let headerImagePath: String
    let galleryImagesPaths: [String]
    let caption: String
    let isLocked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case resource
        case authors
        case headerImagePath
        case galleryImagesPaths
        case caption
        case isLocked
    }
}
