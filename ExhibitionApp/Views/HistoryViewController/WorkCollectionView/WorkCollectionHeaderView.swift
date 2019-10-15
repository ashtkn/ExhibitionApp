import UIKit
import SnapKit

final class WorkCollectionHeaderView: UICollectionReusableView {

    private let viewModel = WorkCollectionHeaderViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let workHeaderLabel = UILabel()
        self.addSubview(workHeaderLabel)
        
        workHeaderLabel.font = UIFont.mainFont(ofSize: 24)
        workHeaderLabel.text = viewModel.workHeaderLabelText
        workHeaderLabel.textAlignment = .left
        workHeaderLabel.textColor = .white
        
        workHeaderLabel.snp.makeConstraints{ make -> Void in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
    }
}
