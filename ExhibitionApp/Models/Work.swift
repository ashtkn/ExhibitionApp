import Foundation

struct Work: Codable, Equatable, Hashable {
    let id: String
    let title: String
    let authors: [Author]
    let images: [String]
    let caption: String
    let url: String
    let isLocked: Bool
    let version: Int
    let resources: [Resource]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case authors
        case images
        case caption
        case url
        case isLocked = "is_locked"
        case version
        case resources
    }
    
    static func ==(lhs: Work, rhs: Work) -> Bool {
        return lhs.id == rhs.id && lhs.version == rhs.version
    }
    
    func has(resource name: String) -> Bool {
        return resources.first(where: { $0.file.base == name} ) != nil
    }
}
