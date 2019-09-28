import Foundation
import RealmSwift

final class DataStore {
    
    static let shared = DataStore()
    let realm = try! Realm()
    
    var works: [Work] {
        return Array(realm.objects(Work.self))
    }
    
    private init() {
        // If UserData does not exist,
        if realm.objects(UserData.self).count == 0 {
            print("Creating new user data")
            let newUserData = UserData()
            newUserData.isFirstLaunch = true
            
            try! realm.write {
                realm.add(newUserData)
            }
        }
        
        guard let userData = realm.object(ofType: UserData.self, forPrimaryKey: 0) else {
            fatalError("UserData is invalid!")
        }
        
        // When app is launched for the first time,
        if userData.isFirstLaunch {
            print("Creating database from JSON file")
            let initialWorkData: [Work] = load("workData.json")
            try! realm.write {
                realm.add(initialWorkData)
                userData.isFirstLaunch = false
            }
        }
    }
    
    private func load<T: Decodable> (_ filename: String, as type: T.Type = T.self) -> T {
        
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
