import UIKit

class LaunchScanningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didScanButtonTapped(_ sender: Any) {
        let scannignViewModel = ScanningViewModel(objects: DataStore.shared.arObjects, images: DataStore.shared.arImages)
        let scanningViewController = ScanningViewController.loadViewControllerFromStoryboard()
        scanningViewController.configure(scannignViewModel)
        
        DispatchQueue.main.async {
            self.present(scanningViewController, animated: true, completion: nil)
        }
    }
}
