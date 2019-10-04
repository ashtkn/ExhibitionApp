import UIKit
import Accounts
import SafariServices

class PreviewViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var declineButton: UIButton!
    
    @IBOutlet private weak var acceptButton: UIButton! {
        didSet {
            if let detectingWork = viewModel?.detectingWork {
                print("Work is detected: \(detectingWork.title)")
                self.acceptButton.isEnabled = true
            } else {
                print("Work is not detected")
                self.acceptButton.isEnabled = false
            }
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = viewModel?.snapshotImage
        }
    }
    
    // MARK: ViewModel
    
    private var viewModel: PreviewViewModel?
    func configure(_ viewModel: PreviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction private func didDeclineButtonTap(_ sender: Any) {
        
        let presentingViewController = self.presentingViewController
        let cameraViewController = CameraViewController.loadViewControllerFromStoryboard()
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                presentingViewController?.present(cameraViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func didAcceptButtonTap(_ sender: Any) {
        
        let presentingViewController = self.presentingViewController
        let detailViewController = DetailViewController.loadViewControllerFromStoryboard()
        
        guard let detectingWork = self.viewModel?.detectingWork else { return }
        detailViewController.configure(DetailViewModel(from: detectingWork))
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                presentingViewController?.present(detailViewController, animated: true, completion: nil)
            }
        }
    }
}
