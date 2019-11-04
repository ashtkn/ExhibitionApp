import UIKit

final class SharingViewControllerViewsBuilder {
    
    static func buildImageView(parent containerView: inout UIView) -> UIImageView {
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        return imageView
    }
    
    static func buildShareButton(parent containerView: inout UIView) -> UIButton {
        let shareButton = UIButton()
        containerView.addSubview(shareButton)
        
        shareButton.backgroundColor = AssetsManager.default.getColor(of: .rectButtonBackground)
        shareButton.layer.cornerRadius = 20
        let titleColor = AssetsManager.default.getColor(of: .rectButtonText)
        shareButton.setTitleColor(titleColor, for: .normal)
        shareButton.titleLabel?.font = UIFont.mainFont(ofSize: 14)
        shareButton.titleLabel?.textAlignment = .center
        shareButton.contentHorizontalAlignment = .center
        shareButton.contentVerticalAlignment = .center
        
        shareButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        return shareButton
    }
    
    static func buildBackButton(parent containerView: inout UIView) -> UIButton {
        let backButton = UIButton()
        containerView.addSubview(backButton)
        
        backButton.setImage(AssetsManager.default.getImage(icon: .leftArrow), for: .normal)
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
        }
        
        return backButton
    }
    
    static func buildSaveSnapshotButton(parent containerView: inout UIView) -> UIButton {
        let saveButton = UIButton()
        containerView.addSubview(saveButton)
        
        saveButton.setImage(AssetsManager.default.getImage(icon: .save), for: .normal)
        
        saveButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        return saveButton
    }
}
