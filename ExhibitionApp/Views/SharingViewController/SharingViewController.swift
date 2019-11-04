import UIKit
import SnapKit
import AVFoundation

final class SharingViewController: UIViewController {
    
    // MARK: Outlets
    private weak var imageView: UIImageView!
    private weak var shareButton: UIButton!
    private weak var backButton: UIButton!
    private weak var saveSnapshotButton: UIButton!

    private var viewModel: SharingViewModel?
    
    private var queuePlayer = AVQueuePlayer()
    private var playerLooper: AVPlayerLooper?
    
    func configure(_ viewModel: SharingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
    }

    private func setupSubviews() {
        var containerView = createContainerView()
        
        imageView = SharingViewControllerViewsBuilder.addImageView(parent: &containerView)

        shareButton = SharingViewControllerViewsBuilder.addShareButton(parent: &containerView)
        shareButton.setTitle(viewModel?.shareButtonTitle, for: .normal)
        shareButton.addTarget(self, action: #selector(didShareButtonTapped(_:)), for: .touchUpInside)
        
        backButton = SharingViewControllerViewsBuilder.addBackButton(parent: &containerView)
        backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)), for: .touchUpInside)
        
        saveSnapshotButton = SharingViewControllerViewsBuilder.addSaveSnapshotButton(parent: &containerView)
        saveSnapshotButton.addTarget(self, action: #selector(didSaveSnapshotButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func createContainerView() -> UIView {
        let containerView = UIView()
        self.view.addSubview(containerView)
        
        let safeArea = self.view.safeArea
        containerView.backgroundColor = AssetsManager.default.getColor(of: .background)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
        
        return containerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch viewModel?.media {
        case .image(let image):
            imageView.image = image
            
        case .video(let path):
            let item = AVPlayerItem(asset: AVAsset(url: path))
            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
            queuePlayer.play()
            
            let playerLayer = AVPlayerLayer(player: queuePlayer)
            playerLayer.frame = imageView.bounds
            playerLayer.videoGravity = .resizeAspect
            imageView.layer.addSublayer(playerLayer)
            
        case .none:
            fatalError()
        }
    }
    
    // MARK: Actions
    
    @objc private func didShareButtonTapped(_ sender: UIButton) {
        switch viewModel?.media {
        case .image(let image):
            let activityItems: [Any] = [image]
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.message, .print]
            
            if System.current.device == .pad {
                activityViewController.popoverPresentationController?.sourceView = imageView
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        case .video(let url):
            // TODO: Implement
            print("Currently not avalibale: \(url)")
            
        case .none:
            fatalError()
        }
    }
    
    @objc private func didBackButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didSaveSnapshotButtonTapped(_ sender: UIButton) {
        switch viewModel?.media {
        case .image(let image):
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(didSavingSnapshotImageSavingFinished(_:didFinishSavingWithError:contextInfo:)), nil)
            
        case .video(let url):
            // TODO: Implement
            print("Currently not avalibale: \(url)")
            
        case .none:
            fatalError()
        }
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
