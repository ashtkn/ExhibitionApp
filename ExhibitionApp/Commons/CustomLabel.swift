import UIKit

open class CustomLabel: UILabel {
    open func setSpacing(_ value: CGFloat) {
        let text = self.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.kern, value: value, range: range)
        self.attributedText = attributedString
    }
}
