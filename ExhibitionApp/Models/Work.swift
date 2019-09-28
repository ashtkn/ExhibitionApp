import Foundation
import RealmSwift

final class Work: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var resource: String = ""
    @objc dynamic var headerImagePath: String = ""
    @objc dynamic var caption: String = ""
    @objc dynamic var isLocked: Bool = true
    
    private var authors = List<String>()
    var authorsList: [String] {
        return Array(authors)
    }
    
    private var galleryImagesPaths = List<String>()
    var galleryImagesPathsList: [String] {
        return Array(galleryImagesPaths)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
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
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.resource = try container.decode(String.self, forKey: .resource)
        self.authors = try container.decode([String].self, forKey: .authors).reduce(List<String>()) { $0.append($1); return $0 }
        self.headerImagePath = try container.decode(String.self, forKey: .headerImagePath)
        self.galleryImagesPaths = try container.decode([String].self, forKey: .galleryImagesPaths).reduce(List<String>()) { $0.append($1); return $0 }
        self.caption = try container.decode(String.self, forKey: .caption)
        self.isLocked = try container.decode(Bool.self, forKey: .isLocked)
    }
}
