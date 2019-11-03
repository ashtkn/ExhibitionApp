import UIKit

final class HistoryViewControllerViewsBuilder {
    
    static func createSubContainerViews(parent containerView: inout UIView) -> (headerViewContainer: UIView, counterViewContainer: UIView, collectionViewContainer: UIView) {
        let headerViewContainer = UIView()
        containerView.addSubview(headerViewContainer)
        
        headerViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        let counterViewContainer = UIView()
        containerView.addSubview(counterViewContainer)
        
        counterViewContainer.snp.makeConstraints { make in
            make.top.equalTo(headerViewContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(233)
        }
        
        let collectionViewContainer = UIView()
        containerView.addSubview(collectionViewContainer)
                
        collectionViewContainer.snp.makeConstraints { make in
            make.top.equalTo(counterViewContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return (headerViewContainer, counterViewContainer, collectionViewContainer)
    }
    
    static func buildHeaderView(parent containerView: inout UIView) -> UILabel {
        let headerView = UIView()
        containerView.addSubview(headerView)
        
        headerView.backgroundColor = ColorManager.shared.findColor(of: .header)
        headerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let label = UILabel()
        headerView.addSubview(label)
        
        label.textColor = ColorManager.shared.findColor(of: .text)
        label.font = .mainFont(ofSize: 16)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return label
    }
    
    static func buildScannedWorksCounterView(parent containerView: inout UIView) -> (textLabel: UILabel, numberLabel: UILabel, progressView: UIProgressView) {
        let scannedWorksCounterView = UIView()
        containerView.addSubview(scannedWorksCounterView)
        
        scannedWorksCounterView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        // Text Label
        let counterTextLabel = UILabel()
        scannedWorksCounterView.addSubview(counterTextLabel)

        counterTextLabel.textColor = ColorManager.shared.findColor(of: .text)
        counterTextLabel.font = .mainFont(ofSize: 18)
        
        counterTextLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
        
        // Number Label
        let counterNumberLabel = UILabel()
        scannedWorksCounterView.addSubview(counterNumberLabel)
        
        counterNumberLabel.textColor = ColorManager.shared.findColor(of: .text)
        counterNumberLabel.font = UIFont(name: "Futura-Bold", size:96)
        
        counterNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Progress View
        let counterProgressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 317, height: 6))
        scannedWorksCounterView.addSubview(counterProgressView)
        
        counterProgressView.progressTintColor = ColorManager.shared.findColor(of: .progressBar)
        counterProgressView.layer.masksToBounds = true
        counterProgressView.layer.cornerRadius = 3.0
        
        counterProgressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(6)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        return (counterTextLabel, counterNumberLabel, counterProgressView)
    }
    
    static func buildScannedWorksCollectionView(parent containerView: inout UIView, padding: CGFloat) -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: padding , left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = padding
        
        let scannedWorksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        scannedWorksCollectionView.backgroundColor = .clear
        containerView.addSubview(scannedWorksCollectionView)
        
        scannedWorksCollectionView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        return scannedWorksCollectionView
    }
    
    static func buildScannedWorksCollectionViewBackgroundView(parent containerView: inout UIView) {
        let textLabel = UILabel()
        textLabel.text = "スキャンがありません"
        textLabel.font = UIFont.mainFont(ofSize: 16)
        textLabel.textColor = ColorManager.shared.findColor(of: .text)
        containerView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let emojiLabel = CustomLabel()
        emojiLabel.text = "😅😅😅"
        emojiLabel.font = UIFont(name: "AppleColorEmoji", size: 48)
        emojiLabel.setSpacing(5)
        containerView.addSubview(emojiLabel)
        
        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-48)
        }
    }
}
