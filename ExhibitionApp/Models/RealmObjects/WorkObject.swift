import Foundation
import RealmSwift

final class WorkObject: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var resource: String = ""
    @objc dynamic var headerImagePath: String = ""
    @objc dynamic var caption: String = ""
    @objc dynamic var isLocked: Bool = true
    
    let authors = List<String>()
    let galleryImagesPaths = List<String>()
    
    static func create(from entity: Work) -> WorkObject {
        let model = WorkObject()
        
        model.id = entity.id
        model.title = entity.title
        model.resource = entity.resource
        model.headerImagePath = entity.headerImagePath
        model.caption = entity.caption
        model.isLocked = entity.isLocked
        model.authors.append(objectsIn: entity.authors)
        model.galleryImagesPaths.append(objectsIn: entity.galleryImagesPaths)
        
        return model
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: Work {
        let authorsArray = Array(authors)
        let galleryImagesPathsArray = Array(galleryImagesPaths)
        
        return Work(id: id, title: title, resource: resource, authors: authorsArray, headerImagePath: headerImagePath, galleryImagesPaths: galleryImagesPathsArray, caption: caption, isLocked: isLocked)
    }
}
