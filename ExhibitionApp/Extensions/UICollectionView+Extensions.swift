import UIKit

extension UICollectionView {
    
    func getNib<T: UICollectionViewCell> (cellType: T.Type) -> T {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! T
    }
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
}
