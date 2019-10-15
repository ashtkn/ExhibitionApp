import UIKit
import SnapKit

class SharingViewController: UIViewController {
    
    // MARK: Outlets
    private weak var imageView: UIImageView!
    private weak var shareButton: UIButton!
    private weak var backButton: UIButton!
    private weak var saveSnapshotButton: UIButton!

    private var viewModel: SharingViewModel?
    
    func configure(_ viewModel: SharingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var container = UIView()
        self.view.addSubview(container)
        
        let safeArea = self.view.safeArea
        container.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
        
        imageView = SharingViewController.addImageView(&container)
        imageView.image = viewModel?.snapshotImage
        
        shareButton = SharingViewController.addShareButton(&container)
        shareButton.setTitle("シェア", for: .normal)
        shareButton.addTarget(self, action: #selector(didShareButtonTapped(_:)), for: .touchUpInside)
        
        backButton = SharingViewController.addBackButton(&container)
        backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)), for: .touchUpInside)
        
        saveSnapshotButton = SharingViewController.addSaveButton(&container)
        saveSnapshotButton.addTarget(self, action: #selector(didSaveSnapshotButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc private func didShareButtonTapped(_ sender: UIButton) {
        guard let image = self.imageView.image else { fatalError() }
        
        let activityItems: [Any] = [image]
        let activityViewController =
            UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.imageView
        }
                
        DispatchQueue.main.async { [unowned self] in
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func didBackButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didSaveSnapshotButtonTapped(_ sender: UIButton) {
        print("Save Image")
    }
}

// MARK: - Views

extension SharingViewController {
    
    private static func addImageView(_ containerView: inout UIView) -> UIImageView {
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        
        // For debug
        imageView.backgroundColor = .blue
        
        // NOTE: ImageViewはデフォルトで `isUserInteractionEnabled == false` なので，UIButtonを子にしても動きません．
        // imageView.isUserInteractionEnabled = true
        
        imageView.snp.makeConstraints { make in
            // NOTE: この制約は実現できません
            // let ratio: CGFloat = 16/9
            // make.top.equalToSuperview()
            // make.width.equalToSuperview()
            // make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        return imageView
    }
    
    private static func addShareButton(_ containerView: inout UIView) -> UIButton {
        let shareButton = UIButton()
        containerView.addSubview(shareButton)
        
        shareButton.backgroundColor = .yellow
        shareButton.layer.cornerRadius = 20
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
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
    
    private static func addBackButton(_ containerView: inout UIView) -> UIButton {
        let backButton = UIButton()
        containerView.addSubview(backButton)
        
        let image = UIImage(named: "outline_keyboard_arrow_left_white_36pt_1x")
        backButton.setImage(image, for: .normal)
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
        }
        
        return backButton
    }
    
    private static func addSaveButton(_ containerView: inout UIView) -> UIButton {
        let saveButton = UIButton()
        containerView.addSubview(saveButton)
        
        let image = UIImage(named: "baseline_save_alt_white_36pt_1x")
        saveButton.setImage(image, for: .normal)
        
        saveButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        return saveButton
    }
}
