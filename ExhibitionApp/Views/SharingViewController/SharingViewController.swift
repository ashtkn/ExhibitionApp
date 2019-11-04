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
        
        imageView = SharingViewControllerViewsBuilder.buildImageView(parent: &containerView)

        shareButton = SharingViewControllerViewsBuilder.buildShareButton(parent: &containerView)
        shareButton.setTitle("シェア", for: .normal)
        shareButton.addTarget(self, action: #selector(didShareButtonTapped(_:)), for: .touchUpInside)
        
        backButton = SharingViewControllerViewsBuilder.buildBackButton(parent: &containerView)
        backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)), for: .touchUpInside)
        
        saveSnapshotButton = SharingViewControllerViewsBuilder.buildSaveSnapshotButton(parent: &containerView)
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
        let activityItems: [Any]
        switch viewModel?.media {
        case .image(let image):
            activityItems = [image]
        case .video(let url):
            activityItems = [url]
        case .none:
            fatalError()
        }
        
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
        switch viewModel?.media {
        case .image(let image):
            PhotoLibraryManager.default.save(image: image) { success in
                DispatchQueue.main.async { [unowned self] in
                    let alertController = self.createAlertController(mediaType: "画像", success: success)
                    self.present(alertController, animated: true, completion: nil)
                }
            }

        case .video(let url):
            PhotoLibraryManager.default.save(video: url.path) { success in
                DispatchQueue.main.async { [unowned self] in
                    let alertController = self.createAlertController(mediaType: "動画", success: success)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        case .none:
            fatalError()
        }
    }
    
    private func createAlertController(mediaType text: String, success: Bool) -> UIAlertController {
        let alertController: UIAlertController
        
        if success {
            alertController = .init(title: "保存完了", message: "\(text)をカメラロールに保存しました", preferredStyle: .alert)
            alertController.addAction(.init(title: "OK", style: .default, handler: nil))
            
        } else {
            alertController = .init(title: "エラー", message: "\(text)の保存に失敗しました", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "設定", style: .cancel) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            }
            alertController.addAction(settingsAction)
            alertController.addAction(.init(title: "後で", style: .default, handler: nil))
        }
        
        return alertController
    }
}
