import UIKit
import SnapKit

class SharingViewController: UIViewController {
    
    // MARK: Outlets
    private weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = viewModel?.snapshotImage
        }
    }
    
    private weak var shareButton: UIButton! {
        didSet {
            self.shareButton.setTitle("シェア", for: .normal)
            self.shareButton.addTarget(self, action: #selector(didShareButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private weak var backButton: UIButton! {
        didSet {
            self.backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private weak var saveSnapshotButton: UIButton! {
        didSet {
            self.saveSnapshotButton.addTarget(self, action: #selector(didSaveSnapshotButtonTapped(_:)), for: .touchUpInside)
        }
    }

    private var viewModel: SharingViewModel?
    
    func configure(_ viewModel: SharingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupSubviews() {
        var container = UIView()
        self.view.addSubview(container)
        
        let safeArea = self.view.safeArea
        container.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
        
        self.imageView = SharingViewController.addImageView(parent: &container)
        self.shareButton = SharingViewController.addShareButton(parent: &container)
        self.backButton = SharingViewController.addBackButton(parent: &container)
        self.saveSnapshotButton = SharingViewController.addSaveSnapshotButton(parent: &container)
    }
    
    // MARK: Actions
    
    @objc private func didShareButtonTapped(_ sender: UIButton) {
        guard let image = self.imageView.image else { fatalError() }
        
        let activityItems: [Any] = [image]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        
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
    
    private static func addImageView(parent containerView: inout UIView) -> UIImageView {
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        return imageView
    }
    
    private static func addShareButton(parent containerView: inout UIView) -> UIButton {
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
    
    private static func addBackButton(parent containerView: inout UIView) -> UIButton {
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
    
    private static func addSaveSnapshotButton(parent containerView: inout UIView) -> UIButton {
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
