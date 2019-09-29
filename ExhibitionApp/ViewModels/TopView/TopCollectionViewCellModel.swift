import UIKit

struct TopCollectionViewCellModel {
    
    let title: String
    var titleText: String {
        return title
    }
    
    let authors: [String]
    
    let imagePath: String
    var image: UIImage? {
        return UIImage(named: imagePath)
    }
    
    var authorsText: String {
        let e0: String = authors[safe: 0] ?? "???"
        let e1: String = authors[safe: 1] ?? ""
        let e2: String = authors[safe: 2] ?? ""
        
        return "\(e0)\n\(e1)\n\(e2)"
    }
    
    init(from work: Work) {
        if work.isLocked {
            self.title = "???"
            self.authors = []
            self.imagePath = "hatena.png"
        } else {
            self.title = work.title
            self.authors = work.authors
            self.imagePath = work.headerImagePath
        }
    }
}
