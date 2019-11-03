import UIKit

final class System {
    
    static let current = System()
    private init() {}
    
    var device: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
}
