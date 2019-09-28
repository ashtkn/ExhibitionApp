import Foundation
import RealmSwift

final class UserData: Object {
    @objc dynamic var id: Int = 0 // Only one
    @objc dynamic var isFirstLaunch: Bool = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
