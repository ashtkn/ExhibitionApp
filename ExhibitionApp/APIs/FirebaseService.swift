import Foundation
import Firebase
import Hydra

final class FirebaseService {
    static let shared = FirebaseService()
    private init() {}
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func signInAsync() ->Promise<Void> {
        return Promise<Void> { resolve, reject, _ in
            if Auth.auth().currentUser != nil { resolve(()) }
            Auth.auth().signInAnonymously { _, error in
                if let error = error {
                    reject(error)
                } else {
                    resolve(())
                }
            }
        }
    }
    
    func fetchWorks() -> Promise<[Work]> {
        return Promise<[Work]> { [unowned self] resolve, reject, _ in
            self.signInAsync().then({
                let collection = Firestore.firestore().collection("works")
                collection.getDocuments { querySnapshot, error in
                    if let error = error {
                        reject(error)
                    } else {
                        guard let querySnapshot = querySnapshot else { fatalError() }
                        let works = querySnapshot.documents.compactMap { try? $0.decode(as: Work.self) }
                        resolve(works)
                    }
                }
            }).catch({ error in
                reject(error)
            })
        }
    }
    
    private func getImageUrl(name: String) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().then({
                let imagePath = "Assets/Images/\(name)"
                let reference = Storage.storage().reference(withPath: imagePath)
                reference.downloadURL { url, error in
                    if let error = error {
                        reject(error)
                    } else {
                        guard let url = url else { fatalError() }
                        resolve(url)
                    }
                }
            }).catch({ error in
                reject(error)
            })
        }
    }
    
    private func getImagesUrls(work: Work) -> Promise<[URL]> {
        return Promise<[URL]> { [unowned self] resolve, reject, _ in
            self.signInAsync().then({
                let imagesPaths = work.images.map { name in
                    return "Assets/Images/\(work.id)/\(name)"
                }
                let imagesReferences = imagesPaths.map { imagePath in
                    return Storage.storage().reference(withPath: imagePath)
                }
                let getUrlsPromises = imagesReferences.map { reference in
                    return Promise<URL> { resolve, reject, _ in
                        reference.downloadURL { url, error in
                            if let error = error {
                                reject(error)
                            } else {
                                guard let url = url else { fatalError() }
                                resolve(url)
                            }
                        }
                    }
                }
                
                all(getUrlsPromises).then({ urls in
                    resolve(urls)
                }).catch({ error in
                    reject(error)
                })
                
            }).catch({ error in
                reject(error)
            })
        }
    }
    
    func download(arobject name: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().then( {
                let reference = Storage.storage().reference(withPath: "Assets/ARObjects/\(name).arobject")
                let path = directory.appendingPathComponent("\(name).arobject")
                reference.write(toFile: path) { url, error in
                    if let error = error {
                        reject(error)
                    } else {
                        guard let url = url else { fatalError() }
                        resolve(url)
                    }
                }
            }).catch({ error in
                reject(error)
            })
        }
    }
    
    func download(image fileName: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().then( {
                let reference = Storage.storage().reference(withPath: "Assets/Images/\(fileName)")
                let path = directory.appendingPathComponent("\(fileName)")
                reference.write(toFile: path) { url, error in
                    if let error = error {
                        reject(error)
                    } else {
                        guard let url = url else { fatalError() }
                        resolve(url)
                    }
                }
            }).catch({ error in
                reject(error)
            })
        }
    }
}
