import Foundation
import RealmSwift

final class AuthorObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var imageName: String = ""
    @objc dynamic var belonging: String = ""
    @objc dynamic var greeting: String = ""
    
    static func create(from entity: Author) -> AuthorObject {
        let model = AuthorObject()
        model.name = entity.name
        model.imageName = entity.imageName
        model.belonging = entity.belonging
        model.greeting = entity.greeting
        
        return model
    }
    
    var entity: Author {
        return Author(name: name, imageName: imageName, belonging: belonging, greeting: greeting)
    }
}
