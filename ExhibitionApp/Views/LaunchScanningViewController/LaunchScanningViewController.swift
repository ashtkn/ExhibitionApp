import UIKit

class LaunchScanningViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            self.scanButton.layer.cornerRadius = self.scanButton.frame.size.width / 2
        }
    }
    
    @IBOutlet weak var moveToHistoryViewButton: UIButton!
    
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
    
    @IBAction private func didMoveToHistoryViewButtonTapped(_ sender: Any) {
        let topPageViewController = self.parent as! TopPageViewController
        topPageViewController.showPage(.historyViewController)
    }
}
