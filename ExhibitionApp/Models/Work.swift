import Foundation

struct Work: Codable, Equatable {
    let id: String
    let title: String
    let resource: String
    let authors: [String]
    let images: [String]
    let caption: String
    let isLocked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case resource
        case authors
        case images
        case caption
        case isLocked = "is_locked"
    }
    
    static func ==(lhs: Work, rhs: Work) -> Bool {
        return lhs.id == rhs.id
    }
}
