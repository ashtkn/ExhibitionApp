import UIKit

final class ColorManager {
    
    enum Item {
        case background
        case header
        case rectButtonBackground
        case rectButtonText
        case circleButton
        case circleButtonBackground
        case text
        case progressBar
    }
    
    static let shared = ColorManager()
    private init() {}
    
    func findColor(of item: Item) -> UIColor {
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
    
    private func convertColor(code colorCode: String) -> UIColor {
        let r = Int(colorCode[1...2], radix: 16)!
        let g = Int(colorCode[3...4], radix: 16)!
        let b = Int(colorCode[5...6], radix: 16)!
        return UIColor(r, g, b)
    }
}
