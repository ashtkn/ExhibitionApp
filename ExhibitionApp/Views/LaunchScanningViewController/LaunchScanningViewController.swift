import UIKit

class LaunchScanningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didScanButtonTapped(_ sender: Any) {
        let navigationViewController = ScanningViewController.loadNavigationControllerFromStoryboard()
        DispatchQueue.main.async {
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
}
