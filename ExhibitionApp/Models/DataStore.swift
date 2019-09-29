import Foundation
import RealmSwift

final class DataStore {
    
    static let shared = DataStore()
    private let realm = try! Realm()
    
    var works: [Work] {
        return Array(realm.objects(WorkObject.self)).map { $0.entity }
    }
    
    var userData: UserData {
        return realm.object(ofType: UserDataObject.self, forPrimaryKey: 0)!.entity
    }
    
    private init() {
        
        // If UserData does not exist,
        if realm.objects(UserDataObject.self).count == 0 {
            
            let newUserData: UserData = UserData(id: 0, isFirstLaunch: true)
            let newUserDataModel: UserDataObject = UserDataObject.create(from: newUserData)
            
            try! realm.write {
                realm.deleteAll()
                realm.add(newUserDataModel)
            }
        }
        
        guard let userDataModel = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0) else {
            fatalError("UserData is invalid!")
        }
        
        let userData = userDataModel.entity
        
        // When app is launched for the first time,
        if userData.isFirstLaunch {
            let initialWorkData: [Work] = JsonUtility.load("workData.json")
            let initialWorkDataModels: [WorkObject] = initialWorkData.map { WorkObject.create(from: $0) }
            try! realm.write {
                realm.add(initialWorkDataModels)
                userDataModel.isFirstLaunch = false
            }
        }
    }
}
