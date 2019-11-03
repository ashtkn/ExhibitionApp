import UIKit

final class AssetsManager {
    
    enum Icon: String, CaseIterable {
        case save = "baseline_save_alt_white_36pt_1x"
        case close = "outline_close_white_36pt_1x"
        case collection = "outline_collections_white_36pt_1x"
        case leftArrow = "outline_keyboard_arrow_left_white_36pt_1x"
    }
    
    enum ImageName: String, CaseIterable {
        case finger = "scan_finger"
    }
    
    static let `default` = AssetsManager()
    private init() {}
    
    func getImage(icon name: Icon) -> UIImage {
        return UIImage(named: name.rawValue)!
    }
    
    func getImage(image imageName: ImageName) -> UIImage {
        return UIImage(named: imageName.rawValue)!
    }
}
