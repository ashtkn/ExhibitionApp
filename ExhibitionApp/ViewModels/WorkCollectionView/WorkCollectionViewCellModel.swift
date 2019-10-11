import UIKit

struct WorkCollectionViewCellModel {
    let title: String
    var titleText: String {
        return title
    }
    
    let imageName: String?
    var image: UIImage? {
        guard let imageName = imageName else { return nil }
        return DataStore.shared.getImage(name: imageName)
    }
    
    init(from work: Work, imageSize: CGSize) {
        if work.isLocked {
            self.title = "???"
            self.imageName = "hatena.png"
        } else {
            self.title = work.title
            self.imageName = work.images.first
        }
    }
}
