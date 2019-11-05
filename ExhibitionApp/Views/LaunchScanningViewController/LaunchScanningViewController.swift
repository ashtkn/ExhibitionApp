import UIKit

final class LaunchScanningViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            self.containerView.backgroundColor = AssetsManager.default.getColor(of: .background)
        }
    }
    
    @IBOutlet private weak var scanButton: UIButton! {
        didSet {
            self.scanButton.layer.cornerRadius = self.scanButton.frame.size.width / 2
            self.scanButton.layer.borderWidth = 4
            self.scanButton.layer.borderColor = AssetsManager.default.getColor(of: .circleButton).cgColor
            self.scanButton.setImage(AssetsManager.default.getImage(image: .finger), for: .normal)
            self.scanButton.tintColor = AssetsManager.default.getColor(of: .circleButton)
            self.scanButton.backgroundColor = AssetsManager.default.getColor(of: .circleButtonBackground)
        }
    }
    
    @IBOutlet private weak var scanTextLabel: UILabel! {
        didSet {
            self.scanTextLabel.text = "作品をARでみよう！"
            self.scanTextLabel.font = UIFont.mainFont(ofSize: 16)
            self.scanTextLabel.textColor = AssetsManager.default.getColor(of: .text)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AssetsManager.default.getColor(of: .background)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.scanButton.layer.borderColor = AssetsManager.default.getColor(of: .circleButton).cgColor
    }
    
    @IBAction private func didScanButtonTapped(_ sender: Any) {
        let navigationViewController = ScanningViewController.loadNavigationControllerFromStoryboard()
        navigationViewController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async { [unowned self] in
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
}
