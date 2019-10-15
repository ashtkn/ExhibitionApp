import UIKit
import SnapKit

class SharingViewController: UIViewController {
    
    // MARK: Outlets
    private weak var container: UIView!
    private weak var imageView: UIImageView!
    private weak var shareButton: UIButton!
    private weak var backButton: UIButton!
    private weak var saveButton: UIButton!

    private var viewModel: SharingViewModel?
    
    func configure(_ viewModel: SharingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // First, setup container
        setupContainer()
        
        // Second, setup components
        setupImageView()
        setupShareButton()
        setupBackButton()
        setupSaveButton()
    }
    
    private func setupContainer() {
        let container = UIView()
        self.view.addSubview(container)
        
        let top = self.view.safeArea.top
        let bottom = self.view.safeArea.bottom
        let leading = self.view.safeArea.leading
        let trailing = self.view.safeArea.trailing
        
        container.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.bottom.equalTo(bottom)
            make.leading.equalTo(leading)
            make.trailing.equalTo(trailing)
        }
        
        self.container = container
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        container.addSubview(imageView)
        
        imageView.image = viewModel?.snapshotImage
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
        
        self.imageView = imageView
    }
    
    private func setupShareButton() {
        let shareButton = UIButton()
        container.addSubview(shareButton)
        
        shareButton.backgroundColor = .yellow
        shareButton.layer.cornerRadius = 20
        shareButton.setTitle("シェア", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.titleLabel?.font = UIFont.mainFont(ofSize: 14)
        shareButton.titleLabel?.textAlignment = .center
        shareButton.contentHorizontalAlignment = .center
        shareButton.contentVerticalAlignment = .center
        
        shareButton.addTarget(self, action: #selector(didShareButtonTapped(_:)), for: .touchUpInside)
        
        shareButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.shareButton = shareButton
    }
    
    private func setupBackButton() {
        let backButton = UIButton()
        container.addSubview(backButton)
        
        let image = UIImage(named: "outline_keyboard_arrow_left_white_36pt_1x")
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)), for: .touchUpInside)
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
        }
        
        self.backButton = backButton
    }
    
    private func setupSaveButton() {
        let saveButton = UIButton()
        container.addSubview(saveButton)
        
        let image = UIImage(named: "baseline_save_alt_white_36pt_1x")
        saveButton.setImage(image, for: .normal)
        saveButton.addTarget(self, action: #selector(didSaveButtonTapped(_:)), for: .touchUpInside)
        
        saveButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        self.saveButton = saveButton
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
    
    @objc private func didSaveButtonTapped(_ sender: UIButton) {
        print("Save Image")
    }
}
