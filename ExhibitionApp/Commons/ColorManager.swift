import UIKit

final class ColorManager {
    enum ColorName: String {
        case mainRed = "#E36263"
        case backgroundWhite = "#F4F4F4"
        case iconBlack = "#212121"
        case headerWhite = "#FEFFFF"
    }
    
    static let `default` = ColorManager()
    private init() {}
    
    func getColor(name colorName: ColorName) -> UIColor {
        let colorCode = colorName.rawValue
        let r = Int(colorCode[1...2], radix: 16)!
        let g = Int(colorCode[3...4], radix: 16)!
        let b = Int(colorCode[5...6], radix: 16)!
        return UIColor(r, g, b)
    }
}
