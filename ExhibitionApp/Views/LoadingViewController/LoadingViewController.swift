import UIKit

final class LoadingViewController: UIViewController {
    
    let viewModel = LoadingViewModel()
    let dataStore = DataStore.shared
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13, *) {
                self.activityIndicatorView.style = .large
            } else {
                self.activityIndicatorView.style = .whiteLarge
            }
            self.activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchProcess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicatorView.stopAnimating()
    }
}

extension LoadingViewController {
    
    private func launchProcess() {
        let hasApplicationDataPrepared = dataStore.hasApplicationDataPrepared()
        
        if !hasApplicationDataPrepared {
            self.launchProcessWhenDataNeedsPreparing()
            return
        }
        
        dataStore.fetchApplicationDataUpdateExists { [unowned self] updateExists, error in
            if updateExists {
                self.launchProcessWhenDataNeedsPreparing()
                return
            }
            
            if let error = error {
                self.presentErrorView(error)
            } else {
                self.moveToTopPageView()
            }
        }
    }
    
    private func launchProcessWhenDataNeedsPreparing() {
        dataStore.createNewApplicationData()
        dataStore.prepareApplicationData { [unowned self] error in
            if let error = error {
                self.presentErrorView(error)
            } else {
                self.moveToTopPageView()
            }
        }
    }
    
    private func moveToTopPageView() {
        let topPageViewController = TopPageViewController.loadViewControllerFromStoryboard()
        topPageViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [unowned self] in
            self.present(topPageViewController, animated: false, completion: nil)
        }
    }
    
    private func presentErrorView(_ error: Error) {
        let alert = viewModel.errorAlert
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async { [unowned self] in
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
