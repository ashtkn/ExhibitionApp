import UIKit

final class LaunchScanningViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            self.scanButton.layer.cornerRadius = self.scanButton.frame.size.width / 2
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
