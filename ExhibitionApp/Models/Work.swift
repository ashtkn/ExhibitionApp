import Foundation

struct Work: Codable {
    let id: Int
    let title: String
    let resource: String
    let authors: [String]
    let headerImagePath: String
    let galleryImagesPaths: [String]
    let description: String
    let isLocked: Bool
}
