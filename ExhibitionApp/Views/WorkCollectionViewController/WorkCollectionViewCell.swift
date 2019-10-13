import UIKit
import SnapKit

class WorkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: WorkCollectionViewCellModel?
    func configure(_ viewModel: WorkCollectionViewCellModel) {
        self.viewModel = viewModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        
        NSLayoutConstraint.activate([
              contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
              contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
              contentView.topAnchor.constraint(equalTo: topAnchor),
              contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // https://terakoya.site/bb/ios10-awakefromnib-frame-size-error/
        self.imageView.image = viewModel?.image
        self.titleLabel.text = viewModel?.title
        
    }
    
    fileprivate func setupView() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
}
