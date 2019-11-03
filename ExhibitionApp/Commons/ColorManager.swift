import UIKit

final class ColorManager {
    
    private enum DefaultModeColorSet: String {
        case mainRed = "#E36263"
        case backgroundWhite = "#F4F4F4"
        case iconBlack = "#212121"
        case headerWhite = "#FEFFFF"
        case white = "#FFFFFF"
    }
    
    private enum DarkModeColorSet: String {
        // TODO: Configue colors for dark mode
        case iconWhite = "#FFFFFF"
    }
    
    enum Item {
        case background
        case header
        case rectButtonBackground
        case rectButtonText
        case circleButton
        case circleButtonBackground
        case text
    }
    
    static let shared = ColorManager()
    private init() {}
    
    func findColor(of item: Item) -> UIColor {
        // TODO: Configue colors for dark mode
        var colorCode: String
        
        switch item {
        case .background:
            colorCode = DefaultModeColorSet.backgroundWhite.rawValue
        case .header:
            colorCode = DefaultModeColorSet.headerWhite.rawValue
        case .rectButtonBackground:
            colorCode = DefaultModeColorSet.mainRed.rawValue
        case .rectButtonText:
            colorCode = DefaultModeColorSet.white.rawValue
        case .circleButton:
            colorCode = DefaultModeColorSet.mainRed.rawValue
        case .circleButtonBackground:
            colorCode = DefaultModeColorSet.white.rawValue
        case .text:
            colorCode = DefaultModeColorSet.iconBlack.rawValue
        }
        
        return convertColor(code: colorCode)
    }
    
    private func convertColor(code colorCode: String) -> UIColor {
        let r = Int(colorCode[1...2], radix: 16)!
        let g = Int(colorCode[3...4], radix: 16)!
        let b = Int(colorCode[5...6], radix: 16)!
        return UIColor(r, g, b)
    }
}
