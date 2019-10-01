import Foundation
import RealmSwift

final class UserDataObject: Object {
    @objc dynamic var id: Int = 0 // Only one
    @objc dynamic var isFirstLaunch: Bool = true
    
    static func create(from entity: UserData) -> UserDataObject {
        let model = UserDataObject()
        model.id = entity.id
        model.isFirstLaunch = entity.isFirstLaunch
        
        return model
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: UserData {
        return UserData(id: id, isFirstLaunch: isFirstLaunch)
    }
}