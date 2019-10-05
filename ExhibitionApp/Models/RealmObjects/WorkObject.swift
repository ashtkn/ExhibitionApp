import Foundation
import RealmSwift

final class WorkObject: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var resource: String = ""
    @objc dynamic var caption: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var isLocked: Bool = true
    
    let images = List<String>()
    let authors = List<String>()
    
    static func create(from entity: Work) -> WorkObject {
        let model = WorkObject()
        
        model.id = entity.id
        model.title = entity.title
        model.resource = entity.resource
        model.caption = entity.caption
        model.url = entity.url
        model.isLocked = entity.isLocked
        model.images.append(objectsIn: entity.images)
        model.authors.append(objectsIn: entity.authors)
        
        return model
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: Work {
        let authorsArray = Array(authors)
        let imagesArray = Array(images)
        
        return Work(id: id, title: title, resource: resource, authors: authorsArray, images: imagesArray, caption: caption, url: url, isLocked: isLocked)
    }
}
