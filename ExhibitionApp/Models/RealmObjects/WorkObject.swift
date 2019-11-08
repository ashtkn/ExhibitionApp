import Foundation
import RealmSwift

final class WorkObject: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var caption: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var isLocked: Bool = true
    @objc dynamic var version: Int = 0
    
    let images = List<String>()
    let authors = List<AuthorObject>()
    let resources = List<ResourceObject>()
    let keywordImages = List<String>()
    
    static func create(from entity: Work) -> WorkObject {
        let model = WorkObject()
        
        model.id = entity.id
        model.title = entity.title
        model.caption = entity.caption
        model.url = entity.url
        model.isLocked = entity.isLocked
        model.images.append(objectsIn: entity.images)
        model.authors.append(objectsIn: entity.authors.map { AuthorObject.create(from: $0) })
        model.resources.append(objectsIn: entity.resources.map { ResourceObject.create(from: $0) })
        model.version = entity.version
        model.keywordImages.append(objectsIn: entity.keywordImages)
        
        return model
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: Work {
        let authorsArray = Array(authors).map { $0.entity }
        let imagesArray = Array(images)
        let resourcesArray = Array(resources).map { $0.entity }
        let keywordImagesArray = Array(keywordImages)
        
        return Work(
            id: id,
            title: title,
            authors: authorsArray,
            images: imagesArray,
            caption: caption,
            url: url,
            isLocked: isLocked,
            version: version,
            resources: resourcesArray,
            keywordImages: keywordImagesArray
        )
    }
}
