import UIKit

struct DetailViewModel {
    
    let id: Int
    let headerImagePath: String
    let title: String
    let authors: [String]
    let caption: String
    let galleryImagesPaths: [String]
    
    var headerImage: UIImage? {
        return UIImage(named: headerImagePath)
    }
    
    var titleText: String {
        return title
    }
    
    var authorsText: String {
        let e0: String = authors[safe: 0] ?? "???"
        let e1: String = authors[safe: 1] ?? ""
        let e2: String = authors[safe: 2] ?? ""
        
        return "\(e0)\n\(e1)\n\(e2)"
    }
    
    init(from work: Work) {
        if work.isLocked {
            fatalError("Implement logic is not appropriate")
        }
        
        self.id = work.id
        self.headerImagePath = work.headerImagePath
        self.title = work.title
        self.authors = work.authorsList
        self.caption = work.caption
        self.galleryImagesPaths = work.galleryImagesPathsList
    }
    
}
