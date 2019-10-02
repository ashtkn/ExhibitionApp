import Foundation
import RealmSwift
import Hydra
import ARKit

enum DataStoreError: Error {
    case fetchError
}

final class DataStore {
    
    static let shared = DataStore()
    private let realm = try! Realm()
    
    // MARK: Initializer
    
    private init() {
        let userDataObject = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0)
        if userDataObject == nil || userDataObject!.entity.isLoadingFiles {
            let newUserData = UserData(id: 0, isFirstLaunch: true, isLoadingFiles: false)
            let newUserDataModel = UserDataObject.create(from: newUserData)
            
            try! realm.write {
                realm.deleteAll()
                realm.add(newUserDataModel)
            }
        }
        
        // Now you can unwrap the user object.
        let userDataModel = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0)!
        let userData = userDataModel.entity
        
        // When app is launched for the first time,
        if userData.isFirstLaunch {
            try! realm.write {
                userDataModel.isLoadingFiles = true
            }
            
            fetchWorkDataAsync().then({
                let realm = try! Realm()
                try! realm.write {
                    userDataModel.isLoadingFiles = false
                    userDataModel.isFirstLaunch = false
                }
            }).catch({ error in
                print(error)
            })
        }
    }
    
    private func fetchWorkDataAsync() -> Promise<Void> {
        
        return Promise<Void> { resolve, reject, _ in
            FirebaseService.shared.fetchWorks().then({ initialWorkData in
                let realm = try! Realm()
                let initialWorkDataModels: [WorkObject] = initialWorkData.map { WorkObject.create(from: $0) }
                try! realm.write {
                    realm.add(initialWorkDataModels)
                }
                
                // Create directory for AR Resources
                let fileManager = FileManager.default
                let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                let resourceDirectory = applicationSupportDirectory.appendingPathComponent("ARObjects", isDirectory: true)
                try fileManager.createDirectory(at: resourceDirectory, withIntermediateDirectories: true, attributes: nil)
                
                // TODO: download AR objects data from Firebase storage
                let resourcesNames = initialWorkData.map { $0.resource }
                let downloadResoucesPromises = resourcesNames.map { resourceName in
                    return FirebaseService.shared.download(arobject: resourceName, to: resourceDirectory)
                }
                
                all(downloadResoucesPromises).then({ resourcesPaths in
                    let resoruces = resourcesPaths.compactMap { try? ARReferenceObject.init(archiveURL: $0) }
                    
                    // TODO:
                    for resource in resoruces {
                        print("Name: \(resource.name!), Center: \(resource.center)")
                    }
                    
                    resolve(())
                    
                }).catch({ error in
                    print(error)
                    reject(DataStoreError.fetchError)
                })
            })
        }
    }
    
    // MARK: Getters
    
    var works: [Work] {
        get {
            return Array(realm.objects(WorkObject.self)).map { $0.entity }
        }
    }
    
    // MARK: Setters
    
    func unlock(work: Work) {
        let workObject = realm.object(ofType: WorkObject.self, forPrimaryKey: work.id)
        try! realm.write {
            workObject?.isLocked = false
        }
    }
    
    func subscribe(_ handler: @escaping () -> Void) -> SubscriptionToken {
        let token = realm.observe { notification, realm in
            handler()
        }
        
        return SubscriptionToken(token: token)
    }
}

struct SubscriptionToken {
    let token: NotificationToken
}
