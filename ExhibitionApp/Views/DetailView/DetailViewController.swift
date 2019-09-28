import UIKit
import Accounts
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var headerImageView: UIImageView! {
        didSet {
            self.headerImageView.image = viewModel?.headerImage
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.text = viewModel?.title
        }
    }
    
    @IBOutlet private weak var authorsLabel: UILabel! {
        didSet {
            self.authorsLabel.text = viewModel?.authorsText
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            self.descriptionLabel.text = viewModel?.caption
        }
    }
    
    @IBOutlet private weak var galleryCollectionView: UICollectionView! {
        didSet {
            self.galleryCollectionView.register(cellType: DetailViewGalleryCollectionViewCell.self)
            self.galleryCollectionView.dataSource = self
            self.galleryCollectionView.delegate = self
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 160, height: 160)
            self.galleryCollectionView.collectionViewLayout = layout
        }
    }
    
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var questionnaireButton: UIButton!
    
    private var viewModel: DetailViewModel?
    
    func configure(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
        // TODO; Unlock the work here if it is locked
        print("Unlock: \(viewModel)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didShareButtonTap(_ sender: Any) {
        // let shareText = "ここに説明文が入ります"
        // let shareLink = "http://www.iiiexhibition.com/"
        guard let shareImage = viewModel?.headerImage else {
            fatalError("Error: image is nil.")
        }
        
        let activityItems: [Any] = [shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        activityViewController.completionWithItemsHandler = completionWithItemsHandler
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = headerImageView
        }
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func didQuestionnaireButtonTap(_ sender: Any) {
        self.presentQuestionnaireWebView()
    }
    
    private var completionWithItemsHandler: (UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void {
        
        return { [unowned self]  _, completed, _, _  in
            
            guard completed else { return }
            
            // When the user accepts the questionnarie,
            let okayAction = UIAlertAction(title: "OK", style: .default) { [unowned self] action in
                self.presentQuestionnaireWebView()
            }
            
            // When the user declines the questionnarie,
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
            // Configure alert controller
            let alertTitle = "写真のシェアありがとうございます！"
            let alertMessage = "ぜひアンケートにご協力ください！"
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            alertController.addAction(okayAction)
            alertController.addAction(cancelAction)
        
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension DetailViewController {
    private func presentQuestionnaireWebView() {
        let questionnaireUrl = URL(string: "https://www.google.co.jp/")!
        let questionnaireViewController = SFSafariViewController(url: questionnaireUrl)
        questionnaireViewController.delegate = self
        
        DispatchQueue.main.async {
            self.present(questionnaireViewController, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.galleryImagesPaths.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(with: DetailViewGalleryCollectionViewCell.self, for: indexPath)
        
        let row = indexPath.row
        guard let imagePath = viewModel?.galleryImagesPaths[row] else {
            fatalError()
        }
        
        cell.configure(DetailViewGalleryCollectionViewCellModel(galleryImagePath: imagePath))
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {}

// MARK: SFSafariViewControllerDelegate

extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {}
}
