import UIKit
import SnapKit

class WorkCollectionHeaderView: UICollectionReusableView {

    lazy var workHeaderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setupView()
        setupLayout()
    }
    
    fileprivate func setupView(){
        self.addSubview(workHeaderLabel)
        workHeaderLabel.font = UIFont(name: "HiraginoSans-W6", size:24)
        workHeaderLabel.text = "スキャンした作品"
        workHeaderLabel.textAlignment = .left
        workHeaderLabel.textColor = .white
    }
    
    fileprivate func setupLayout(){
        workHeaderLabel.snp.makeConstraints{ make -> Void in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
    }
}
