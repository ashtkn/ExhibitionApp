import UIKit

class LaunchScanningViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var collectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanButton.layer.cornerRadius = scanButton.frame.size.width/2
        
    }
    

    
    @IBAction private func didScanButtonTapped(_ sender: Any) {
        let navigationViewController = ScanningViewController.loadNavigationControllerFromStoryboard()
        DispatchQueue.main.async { [unowned self] in
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
}
