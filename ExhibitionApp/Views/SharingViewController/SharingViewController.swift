import UIKit

class SharingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = sharingViewModel?.snapshotImage
        }
    }
    
    @IBOutlet weak var shareButton: UIButton!
    
    var sharingViewModel: SharingViewModel?
    func configure(_ sharingViewModel: SharingViewModel) {
        self.sharingViewModel = sharingViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didShareButtonTapped(_ sender: Any) {
        // let shareText = "ここに説明文が入ります"
        // let shareLink = "http://www.iiiexhibition.com/"
        guard let image = self.imageView.image else { fatalError() }
        
        let activityItems: [Any] = [image]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        // activityViewController.completionWithItemsHandler = completionWithItemsHandler
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.imageView
        }
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
