import Foundation

struct Work: Codable, Equatable, Hashable {
    let id: String
    let title: String
    let resource: String
    let authors: [String]
    let images: [String]
    let caption: String
    let url: String
    let isLocked: Bool
    let version: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case resource
        case authors
        case images
        case caption
        case url
        case isLocked = "is_locked"
        case version
    }
    
    static func ==(lhs: Work, rhs: Work) -> Bool {
        return lhs.id == rhs.id && lhs.version == rhs.version
    }
}
