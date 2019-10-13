import UIKit
import SnapKit

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
}
