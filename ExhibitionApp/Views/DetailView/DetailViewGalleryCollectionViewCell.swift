import UIKit

class DetailViewGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(_ viewModel: DetailViewGalleryCollectionViewCellModel) {
        self.imageView.image = viewModel.galleryImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
