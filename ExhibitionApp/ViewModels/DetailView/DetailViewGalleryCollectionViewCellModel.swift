import UIKit

struct DetailViewGalleryCollectionViewCellModel {
    
    let galleryImagePath: String
    var galleryImage: UIImage? {
        return UIImage(named: galleryImagePath)
    }
}
