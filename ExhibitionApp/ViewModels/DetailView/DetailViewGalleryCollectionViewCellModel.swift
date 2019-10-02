import UIKit

struct DetailViewGalleryCollectionViewCellModel {
    let galleryImagePath: String
    var galleryImage: UIImage? {
        let path = DataStore.shared.imagesDirectory.appendingPathComponent(galleryImagePath).path
        return UIImage(contentsOfFile: path)
    }
}
