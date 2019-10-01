import Foundation
import Firebase

final class FirebaseService {
    
    static let shared = FirebaseService()
    private init() {}
    
    func configure() {
        FirebaseApp.configure()
    }
}
