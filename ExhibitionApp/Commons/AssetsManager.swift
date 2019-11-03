import UIKit

final class AssetsManager {
    
    enum IconName: String, CaseIterable {
        case save = "baseline_save_alt_white_36pt_1x"
        case close = "outline_close_white_36pt_1x"
        case collection = "outline_collections_white_36pt_1x"
        case leftArrow = "outline_keyboard_arrow_left_white_36pt_1x"
    }
    
    enum ImageName: String, CaseIterable {
        case finger = "scan_finger"
    }
    
    enum ColorItem {
        case background
        case header
        case rectButtonBackground
        case rectButtonText
        case circleButton
        case circleButtonBackground
        case text
        case progressBar
    }
    
    static let `default` = AssetsManager()
    private init() {}
    
    func getImage(icon name: IconName) -> UIImage {
        return UIImage(named: name.rawValue)!
    }
    
    func getImage(image name: ImageName) -> UIImage {
        return UIImage(named: name.rawValue)!
    }
    
    func getColor(of item: ColorItem) -> UIColor {
        switch item {
        case .background:
            return UIColor(named: "BackgroundDefault")!
        case .header, .circleButtonBackground:
            return UIColor(named: "BackgroundLight")!
        case .rectButtonBackground, .circleButton, .progressBar:
            return UIColor(named: "ComponentsDefault")!
        case .rectButtonText:
            return UIColor(named: "TextReversed")!
        case .text:
            return UIColor(named: "TextDefault")!
        }
    }
}
