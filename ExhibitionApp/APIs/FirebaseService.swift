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
}
