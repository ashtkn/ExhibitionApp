import UIKit
import SnapKit

class SharingViewController: UIViewController {
    
    // MARK: Outlets
    
    lazy var imageView = UIImageView()
    lazy var containerView = UIImageView()
    
    lazy var shareButton = UIButton()
    lazy var backButton = UIButton()
    lazy var saveButton = UIButton()

    // MARK: ViewModel
    
    private var sharingViewModel: SharingViewModel?
    func configure(_ sharingViewModel: SharingViewModel) {
        self.sharingViewModel = sharingViewModel
    }

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.view.backgroundColor = .black
        setupImageView()
        setupContainerView()
        setupShareButton()
        setupBackButton()
        setupSaveButton()
        
    }
    
    private func setupImageView() {
        self.view.addSubview(imageView)
        
        // imageView.image = sharingViewModel?.snapshotImage
        imageView.backgroundColor = .systemBlue
    }
    
    private func setupContainerView() {
        self.view.addSubview(containerView)
        
        containerView.backgroundColor = .systemRed
    }
    
    private func setupShareButton() {
        containerView.addSubview(shareButton)
        
        shareButton.backgroundColor = .yellow
        shareButton.layer.cornerRadius = 20
        shareButton.setTitle("シェア", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.titleLabel?.font = UIFont.mainFont(ofSize: 14)
        shareButton.titleLabel?.textAlignment = .center
        shareButton.contentHorizontalAlignment = .center
        shareButton.contentVerticalAlignment = .center

        shareButton.addTarget(self, action: #selector(didShareButtonTapped), for: .touchUpInside)
    }
    
    private func setupBackButton() {
        imageView.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        
        let image = UIImage(named: "outline_keyboard_arrow_left_white_36pt_1x")
        backButton.setImage(image, for: .normal)
    }
    
    private func setupSaveButton() {
        imageView.addSubview(saveButton)
        
        let image = UIImage(named: "baseline_save_alt_white_36pt_1x")
        saveButton.setImage(image, for: .normal)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints{ (make) -> Void in
            let ratio:CGFloat = 16/9
            make.top.equalToSuperview().offset(44)
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
        }
        
        containerView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(40)
            make.center.equalToSuperview()
        }
        
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.left.equalToSuperview().offset(18)
        }
        
        saveButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().inset(18)
        }
    }
    
}
    
    // MARK: Actions
    
extension SharingViewController {
    @objc private func didShareButtonTapped(sender: UIButton) {
        
        // let shareText = "ここに説明文が入ります"
        // let shareLink = "http://www.iiiexhibition.com/"
        guard let image = self.imageView.image else { fatalError() }
        
        let activityItems: [Any] = [image]
        let activityViewController =
            UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message, .print]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.imageView
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
       // DispatchQueue.main.async { [unowned self] in
       //     self.present(activityViewController, animated: true, completion: nil)
       // }
    }
    
    @objc private func didBackButtonTapped(sender: UIButton) {
        //DispatchQueue.main.async { [unowned self] in
        //    self.navigationController?.popViewController(animated: true)
        //}
            self.navigationController?.popViewController(animated: true)
    }


   // @IBAction private func didCancelButtonTapped(_ sender: Any) {
   //     DispatchQueue.main.async { [unowned self] in
   //         self.navigationController?.dismiss(animated: true, completion: nil)
   //     }
   // }
}
