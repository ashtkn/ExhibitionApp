import UIKit
import SnapKit

final class SharingViewController: UIViewController {
    
    // MARK: Outlets
    private weak var imageView: UIImageView! {
        didSet {
            switch viewModel?.media {
            case .image(let image):
                self.imageView.image = image
            case .images(let images):
                self.imageView.image = images.last
            case .video(let url):
                print("Video at \(url)")
            case .none:
                fatalError()
            }
        }
    }
    
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
        self.setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupSubviews() {
        var containerView = createContainerView()
        self.imageView = SharingViewControllerViewsBuilder.addImageView(parent: &containerView)
        
        self.shareButton = SharingViewControllerViewsBuilder.addShareButton(parent: &containerView)
        self.shareButton.setTitle(viewModel?.shareButtonTitle, for: .normal)
        self.shareButton.addTarget(self, action: #selector(didShareButtonTapped(_:)), for: .touchUpInside)
        
        self.backButton = SharingViewControllerViewsBuilder.addBackButton(parent: &containerView)
        self.backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)), for: .touchUpInside)
        
        self.saveSnapshotButton = SharingViewControllerViewsBuilder.addSaveSnapshotButton(parent: &containerView)
        self.saveSnapshotButton.addTarget(self, action: #selector(didSaveSnapshotButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func createContainerView() -> UIView {
        let containerView = UIView()
        self.view.addSubview(containerView)
        
        let safeArea = self.view.safeArea
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
        
        return containerView
    }
    
    // MARK: Actions
    
    @objc private func didShareButtonTapped(_ sender: UIButton) {
        // TODO: 動画に対応
        guard let image = self.imageView.image else { fatalError() }
        
        let activityItems: [Any] = [image]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        
        if System.current.device == .pad {
            activityViewController.popoverPresentationController?.sourceView = imageView
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
        // TODO: 動画に対応
        guard let image = self.imageView.image else { fatalError() }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didSavingSnapshotImageSavingFinished(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func didSavingSnapshotImageSavingFinished(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var alert = viewModel!.imageSavingSuccessAlert
        if let _ = error {
            alert = viewModel!.imageSavingErrorAlert
        }
        
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async { [unowned self] in
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
