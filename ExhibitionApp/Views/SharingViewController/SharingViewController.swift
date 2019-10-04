import UIKit

class SharingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = sharingViewModel?.snapshotImage
        }
    }
    
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    
    // MARK: ViewModel
    
    private var sharingViewModel: SharingViewModel?
    func configure(_ sharingViewModel: SharingViewModel) {
        self.sharingViewModel = sharingViewModel
    }

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction private func didShareButtonTapped(_ sender: Any) {
        // let shareText = "ここに説明文が入ります"
        // let shareLink = "http://www.iiiexhibition.com/"
        guard let image = self.imageView.image else { fatalError() }
        
        let activityItems: [Any] = [image]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.imageView
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func didBackButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func didCancelButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
