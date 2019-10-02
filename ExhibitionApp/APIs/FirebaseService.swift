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
    
    func download(arobject fileName: String, to directory: URL) -> Promise<URL> {
        return Promise<URL> { [unowned self] resolve, reject, _ in
            self.signInAsync().then( {
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
