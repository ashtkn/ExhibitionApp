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
    
    private init() {
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: Properties
    
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
    
    var profileImagesDirectory: URL {
        let profileImagesDirectory = applicationSupportDirectory.appendingPathComponent("ProfileImages", isDirectory: true)
        try! FileManager.default.createDirectory(at: profileImagesDirectory, withIntermediateDirectories: true, attributes: nil)
        return profileImagesDirectory
    }
    
    var keywordImagesDirectory: URL {
        let keywordImagesDirectory = applicationSupportDirectory.appendingPathComponent("KeywordImages", isDirectory: true)
        try! FileManager.default.createDirectory(at: keywordImagesDirectory, withIntermediateDirectories: true, attributes: nil)
        return keywordImagesDirectory
    }
    
    var allWorks: [Work] {
        let realm = try! Realm()
        return Array(realm.objects(WorkObject.self)).map { $0.entity }
    }
    
    var unlockedWorks: [Work] {
        return allWorks.filter { !$0.isLocked }
    }
    
    var debugDescription: String {
        return "Works: \(allWorks.count), ARObjectReferences: \(getARObjects()), ARImageReferences: \(getARImages().count)"
    }
    
    // MARK: Methods
    // MARK: Preparing data
    
    func createNewApplicationData() {
        let realm = try! Realm()
        let newUserData = UserData(id: 0, isFirstLaunch: true, isLoadingFiles: false)
        let newUserDataObject = UserDataObject.create(from: newUserData)
        
        try! realm.write {
            realm.deleteAll()
            realm.add(newUserDataObject)
        }
    }
    
    func prepareApplicationData(completion handler: ((_ error: Error?) -> Void)?) {
        let realm = try! Realm()
        guard let userDataObject = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0) else { fatalError() }
        
        try! realm.write {
            userDataObject.isLoadingFiles = true
        }
        
        downloadApplicationDataAsync().then({
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
    
    func hasApplicationDataPrepared() -> Bool {
        let realm = try! Realm()
        if let userDataObject = realm.object(ofType: UserDataObject.self, forPrimaryKey: 0) {
            let userData = userDataObject.entity
            if !userData.isFirstLaunch && !userData.isLoadingFiles {
                return true
            }
        }
        return false
    }
    
    func fetchApplicationDataUpdateExists(completion handler: ((_ updated: Bool, _ error: Error?) -> Void)?) {
        let fetchedWorksSet = Set<Work>(allWorks)
        FirebaseService.shared.fetchWorks().then({ fetchingWorks in
            let fetchingWorksSet = Set<Work>(fetchingWorks)
            let diff = fetchingWorksSet.subtracting(fetchedWorksSet)
            let updated = diff.count > 0
            handler?(updated, nil)
        }).catch({ error in
            handler?(false, error)
        })
    }
    
    // MARK: Using data
    
    func getImage(name imageName: String) -> UIImage? {
        let imagePath = imagesDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    func getProfileImage(name imageName: String) -> UIImage? {
        let profileImagePath = profileImagesDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: profileImagePath.path)
    }
    
    func getKeywordImage(name imageName: String) -> UIImage? {
        let keywordImagePath = profileImagesDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: keywordImagePath.path)
    }
    
    func getARObjectsSet() -> Set<ARReferenceObject> {
        let arObjects = getARObjects()
        return Set(arObjects)
    }
    
    func getARImagesSet() -> Set<ARReferenceImage> {
        let arImages = getARImages()
        return Set(arImages)
    }
    
    func subscribe(_ handler: @escaping () -> Void) -> SubscriptionToken {
        let realm = try! Realm()
        let token = realm.observe { notification, realm in
            handler()
        }
        
        return SubscriptionToken(token: token)
    }
    
    // MARK: Operating data
    
    func unlock(work: Work) {
        let realm = try! Realm()
        let workObject = realm.object(ofType: WorkObject.self, forPrimaryKey: work.id)
        try! realm.write {
            workObject?.isLocked = false
        }
    }
}

extension DataStore {
    
    private var applicationSupportDirectory: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
    
    private var config: Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: WorkObject.className()) { oldObject, newObject in
                        newObject!["version"] = -1
                    }
                }
                if (oldSchemaVersion < 2) {
                    migration.enumerateObjects(ofType: WorkObject.className()) { oldObject, newObject in
                        let resources = List<ResourceObject>()
                        let resourceName = oldObject!["resource"] as! String
                        let ext = resourceName.components(separatedBy: ".").last!
                        
                        switch(ext) {
                        case "arobject":
                            let resource = Resource(type: "object", filename: resourceName, size: nil)
                            resources.append(ResourceObject.create(from: resource))
                        case "jpg":
                            let resource = Resource(type: "image", filename: resourceName, size: 0.127)
                            resources.append(ResourceObject.create(from: resource))
                        default:
                            break
                        }
                        
                        newObject!["resources"] = resources
                    }
                }
                if (oldSchemaVersion < 3) {
                    migration.enumerateObjects(ofType: WorkObject.className()) { oldObject, newObject in
                        let authors = List<AuthorObject>()
                        newObject!["authors"] = authors
                    }
                }
                if (oldSchemaVersion < 4) {
                    migration.enumerateObjects(ofType: WorkObject.className()) { oldObject, newObject in
                        newObject!["keywordImages"] = List<String>()
                    }
                }
        })
    }
    
    private func downloadApplicationDataAsync() -> Promise<Void> {
        
        return Promise<Void> { resolve, reject, _ in
            FirebaseService.shared.fetchWorks().then({ [unowned self] initialWorkData in
                let initialWorkDataModels: [WorkObject] = initialWorkData.map { WorkObject.create(from: $0) }
                
                // Create promises for downloading resources
                let resourcesNames = initialWorkData.flatMap { $0.resources.map { $0.filename } }
                let downloadResoucesPromises: [Promise<URL>] = resourcesNames.map { resourceName in
                    return FirebaseService.shared.download(resource: resourceName, to: self.resourcesDirectory)
                }
                
                // Create promises for downloading images
                let downloadImagesPromises: [Promise<URL>] = initialWorkData.flatMap { work in
                    return work.images.map { imageName in
                        FirebaseService.shared.download(image: imageName, to: self.imagesDirectory)
                    }
                }
                
                let downloadProfileImagesPromises: [Promise<URL>] = initialWorkData.flatMap { work in
                    return work.authors.map { author in
                        return FirebaseService.shared.download(profileImage: author.imageName, to: self.profileImagesDirectory)
                    }
                }
                
                let downloadKeywordImagesPromises: [Promise<URL>] = initialWorkData.flatMap { work in
                    return work.keywordImages.map { imageName in
                        return FirebaseService.shared.download(keywordImage: imageName, to: self.keywordImagesDirectory)
                    }
                }
                
                // Execute downloading
                zip(a: all(downloadResoucesPromises), b: all(downloadImagesPromises), c: all(downloadProfileImagesPromises), d: all(downloadKeywordImagesPromises)).then({ resourcesPaths, imagesPaths, profileImagesPaths, keywordImagesPaths in
                    // Register fetched data to Realm database
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(initialWorkDataModels)
                    }
                    
                    resolve(())
                }).catch({ _ in
                    reject(DataStoreError.fetchError)
                })
            })
        }
    }
    
    private func getARObjects() -> [ARReferenceObject] {
        let arObjects: [ARReferenceObject] = allWorks.flatMap { (work: Work) -> [ARReferenceObject] in
            let resourcesDirectory = self.resourcesDirectory
            let referenceObjects: [ARReferenceObject] = work.resources.compactMap { resource in
                let resourcePath = resourcesDirectory.appendingPathComponent("\(resource.filename)")
                if resource.type == "object" {
                    let referenceObject = try? ARReferenceObject.init(archiveURL: resourcePath)
                    referenceObject?.name = resource.file.base
                    return referenceObject
                }
                return nil
            }
            return referenceObjects
        }
        return arObjects
    }
    
    private func getARImages() -> [ARReferenceImage] {
        let arImages: [ARReferenceImage] = allWorks.flatMap { (work: Work) -> [ARReferenceImage] in
            let resourcesDirectory = self.resourcesDirectory
            let referencesImages: [ARReferenceImage] = work.resources.compactMap { resource in
                let resourcePath = resourcesDirectory.appendingPathComponent("\(resource.filename)")
                let physicalWidth = resource.size ?? 0.127 // L-Size
                
                if resource.type == "image" {
                    guard let image = UIImage(contentsOfFile: resourcePath.path) else { return nil }
                    guard let cgImage = image.cgImage else { return nil }
                    let referenceImage = ARReferenceImage.init(cgImage, orientation: .init(image.imageOrientation), physicalWidth: CGFloat(physicalWidth))
                    referenceImage.name = resource.file.base
                    return referenceImage
                }
                return nil
            }
            return referencesImages
        }
        return arImages
    }
}
