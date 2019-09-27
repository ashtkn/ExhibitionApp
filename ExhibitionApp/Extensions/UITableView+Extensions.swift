import UIKit

extension UITableView {
    
    func getNib<T: UITableViewCell> (cellType: T.Type) -> T {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! T
    }
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

