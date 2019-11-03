import UIKit

final class LaunchScanningViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.backgroundColor = ColorManager.default.getColor(name: .backgroundWhite)
        }
    }
    
    @IBOutlet private weak var scanButton: UIButton! {
        didSet {
            self.scanButton.layer.cornerRadius = self.scanButton.frame.size.width / 2
            self.scanButton.layer.borderWidth = 1
            self.scanButton.layer.borderColor = ColorManager.default.getColor(name: .mainRed).cgColor
            self.scanButton.setImage(AssetsManager.default.getImage(image: .finger), for: .normal)
            self.scanButton.tintColor = ColorManager.default.getColor(name: .mainRed)
            self.scanButton.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var scanTextLabel: UILabel! {
        didSet {
            self.scanTextLabel.text = "作品をARでみよう！"
            self.scanTextLabel.textColor = ColorManager.default.getColor(name: .iconBlack)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didScanButtonTapped(_ sender: Any) {
        let navigationViewController = ScanningViewController.loadNavigationControllerFromStoryboard()
        navigationViewController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async { [unowned self] in
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
}
