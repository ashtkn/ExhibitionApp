import UIKit
import SnapKit

class WorkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var viewModel: WorkCollectionViewCellModel?
    func configure(_ viewModel: WorkCollectionViewCellModel) {
        self.viewModel = viewModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.image = viewModel?.image
        self.titleLabel.text = viewModel?.title
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
}
