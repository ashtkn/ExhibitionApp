import UIKit

class LaunchScanningViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            self.scanButton.layer.cornerRadius = self.scanButton.frame.size.width / 2
        }
    }
    
    @IBOutlet weak var collectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didScanButtonTapped(_ sender: Any) {
        let navigationViewController = ScanningViewController.loadNavigationControllerFromStoryboard()
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.navigationBar.isTranslucent = true
        navigationViewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationViewController.navigationBar.shadowImage = UIImage()
        navigationViewController.navigationBar.tintColor = .white
        navigationViewController.navigationItem.title = ""

        DispatchQueue.main.async { [unowned self] in
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func didCollectionButtonTapped(_ sender: Any) {
        let topPageViewController = self.parent as! TopPageViewController
        // NOTE: 理由は不明だがこれで動く．要動作確認．
        topPageViewController.showPage(.launchScanningViewController)
    }
}
