import Foundation
import RealmSwift

final class ResourceObject: Object {
    @objc dynamic var type: String = ""
    @objc dynamic var filename: String = ""
    let size = RealmOptional<Float>()
    
    static func create(from entity: Resource) -> ResourceObject {
        let model = ResourceObject()
        model.type = entity.type
        model.filename = entity.filename
        model.size.value = entity.size
        
        return model
    }
    
    var entity: Resource {
        return Resource(type: type, filename: filename, size: size.value)
    }
}
