import Foundation
import Firebase
import Hydra

final class FirebaseService {
    static let shared = FirebaseService()
    private init() {}
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func signInAsync() ->Promise<User> {
        return Promise<User> { resolve, reject, _ in
            if let currentUser = Auth.auth().currentUser {
                resolve(currentUser)
            }
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    reject(error)
                } else {
                    resolve(authResult!.user)
                }
            }
        }
    }
    
    func fetchWorks() -> Promise<[Work]> {
        return Promise<[Work]> { [unowned self] resolve, reject, _ in
            self.signInAsync().retry(3).timeout(timeout: 5.0).then({ _ in
                let collection = Firestore.firestore().collection("works")
                collection.getDocuments { querySnapshot, error in
                    if let error = error {
                        reject(error)
                    } else {
                        guard let querySnapshot = querySnapshot else { fatalError() }
                        let works: [Work] = querySnapshot.documents.compactMap { document in
                            do {
                                return try document.decode(as: Work.self)
                            } catch {
                                print("Decoding error: \(error)")
                                return nil
                            }
                        }
                        resolve(works)
                    }
                }
            }).catch({ error in
                reject(error)
            })
        }
    }
    
    func download(resource fileName: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().retry(3).timeout(timeout: 5.0).then( { _ in
                let reference = Storage.storage().reference(withPath: "Assets/Resources/\(fileName)")
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
    
    func download(image fileName: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().retry(3).timeout(timeout: 5.0).then( { _ in
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
    
    func download(profileImage fileName: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().retry(3).timeout(timeout: 5.0).then( { _ in
                let reference = Storage.storage().reference(withPath: "Assets/ProfileImages/\(fileName)")
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
    
    func download(keywordImage fileName: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().retry(3).timeout(timeout: 5.0).then( { _ in
                let reference = Storage.storage().reference(withPath: "Assets/KeywordImages/\(fileName)")
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
    
    func vote(for handType: Int) -> Promise<Void> {
        return Promise<Void> { [unowned self] resolve, reject, _ in
            self.signInAsync().retry(3).timeout(timeout: 5.0).then( { currentUser in
                let userId = currentUser.uid
                let data: [String: Any] = [
                    "userId": "\(userId)",
                    "handType": handType
                ]
                
                let doc = Firestore.firestore().collection("votes").document("\(userId)")
                doc.setData(data) { error in
                    if let error = error {
                        reject(error)
                    } else {
                        resolve(())
                    }
                }
            }).catch({ error in
                reject(error)
            })
        }
    }
}
