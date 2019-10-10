import Foundation
import RealmSwift
import Hydra
import ARKit

enum DataStoreError: Error {
    case fetchError
}

final class DataStore {
    
    static let shared = DataStore()
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Properties
    
    private var applicationSupportDirectory: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
    
    var resourcesDirectory: URL {
        let resourcesDirectory = applicationSupportDirectory.appendingPathComponent("Resources", isDirectory: true)
        try! FileManager.default.createDirectory(at: resourcesDirectory, withIntermediateDirectories: true, attributes: nil)
        return resourcesDirectory
    }
    
    var imagesDirectory: URL {
        let imagesDirectory = applicationSupportDirectory.appendingPathComponent("Images", isDirectory: true)
        try! FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
        return imagesDirectory
    }
    
    var works: [Work] {
        let realm = try! Realm()
        return Array(realm.objects(WorkObject.self)).map { $0.entity }
    }
    
    var hasCompletedSetup: Bool {
        let realm = try! Realm()
        if let userDataObject = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0) {
            let userData = userDataObject.entity
            if !userData.isFirstLaunch && !userData.isLoadingFiles {
                return true
            }
        }
        return false
    }
    
    // MARK: Methods
    
    func createNewUserData() {
        let realm = try! Realm()
        let newUserData = UserData(id: 0, isFirstLaunch: true, isLoadingFiles: false)
        let newUserDataObject = UserDataObject.create(from: newUserData)
        
        try! realm.write {
            realm.deleteAll()
            realm.add(newUserDataObject)
        }
    }
    
    func downloadFiles(completion handler: ((_ error: Error?) -> Void)?) {
        let realm = try! Realm()
        guard let userDataObject = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0) else { fatalError() }
        
        try! realm.write {
            userDataObject.isLoadingFiles = true
        }
        
        fetchWorkDataAsync().then({
            let realm = try! Realm()
            try! realm.write {
                userDataObject.isLoadingFiles = false
                userDataObject.isFirstLaunch = false
            }
            handler?(nil)
            
        }).catch({ error in
            handler?(error)
        })
    }
    
    func getImage(name imageName: String) -> UIImage? {
        let imagePath = imagesDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    func getARObjectsSet() -> Set<ARReferenceObject> {
        let arObjects: [ARReferenceObject] = works.compactMap { work in
            let resourcePath = resourcesDirectory.appendingPathComponent("\(work.resource)")
            if resourcePath.pathExtension != "arobject" {
                return nil
            }
            let referenceObject = try? ARReferenceObject.init(archiveURL: resourcePath)
            referenceObject?.name = "\(work.title)"
            
            return referenceObject
        }
        return Set(arObjects)
    }
    
    func getARImagesSet() -> Set<ARReferenceImage> {
        let arImages: [ARReferenceImage] = works.compactMap { work in
            let resourcePath = resourcesDirectory.appendingPathComponent("\(work.resource)")
            if resourcePath.pathExtension != "jpg" {
                return nil
            }
            
            guard let image = UIImage(contentsOfFile: resourcePath.path) else {
                print("Cannot load image")
                return nil
            }
            guard let cgImage = image.cgImage else {
                print("Cannot export CGImage")
                return nil
            }
            
            let physicalWidth: CGFloat = 0.127 // You have to fix the real size of the image marker.
            let referenceImage = ARReferenceImage.init(cgImage, orientation: .init(image.imageOrientation), physicalWidth: physicalWidth)
            referenceImage.name = "\(work.title)"
            
            return referenceImage
        }
        return Set(arImages)
    }
    
    func unlock(work: Work) {
        let realm = try! Realm()
        let workObject = realm.object(ofType: WorkObject.self, forPrimaryKey: work.id)
        try! realm.write {
            workObject?.isLocked = false
        }
    }
    
    func subscribe(_ handler: @escaping () -> Void) -> SubscriptionToken {
        let realm = try! Realm()
        let token = realm.observe { notification, realm in
            handler()
        }
        
        return SubscriptionToken(token: token)
    }
}

extension DataStore {
    
    private func fetchWorkDataAsync() -> Promise<Void> {
        
        return Promise<Void> { resolve, reject, _ in
            FirebaseService.shared.fetchWorks().then({ [unowned self] initialWorkData in
                let initialWorkDataModels: [WorkObject] = initialWorkData.map { WorkObject.create(from: $0) }
                
                // Create promises for downloading resources
                let resourcesNames = initialWorkData.map { $0.resource }
                let downloadResoucesPromises: [Promise<URL>] = resourcesNames.map { resourceName in
                    return FirebaseService.shared.download(resource: resourceName, to: self.resourcesDirectory)
                }
                
                // Create promises for downloading images
                var downloadImagesPromises: [Promise<URL>] = initialWorkData.flatMap { work in
                    return work.images.map { imageName in
                        FirebaseService.shared.download(image: imageName, to: self.imagesDirectory)
                    }
                }
                
                // Add promise for downloading hatena.png
                let downloadHatenaImagePromise = FirebaseService.shared.download(image: "hatena.png", to: self.imagesDirectory)
                downloadImagesPromises.append(downloadHatenaImagePromise)
                
                // Execute downloading
                zip(all(downloadResoucesPromises), all(downloadImagesPromises)).then({ resourcesPaths, imagesPaths in
                    print("Downloaded resources: \(resourcesPaths)")
                    print("Downloaded images: \(imagesPaths)")
                    
                    // Register fetched data to Realm database
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(initialWorkDataModels)
                    }
                    
                    resolve(())
                }).catch({ error in
                    print(error)
                    reject(DataStoreError.fetchError)
                })
            })
        }
    }
}
