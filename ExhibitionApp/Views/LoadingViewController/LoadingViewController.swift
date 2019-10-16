import UIKit

final class LoadingViewController: UIViewController {
    
    let viewModel = LoadingViewModel()
    
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
        
        if DataStore.shared.hasCompletedSetup {
            checkForUpdates()
        } else {
            initialSetup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicatorView.stopAnimating()
    }
    
    private func initialSetup() {
        DataStore.shared.createNewUserData()
        DataStore.shared.downloadFiles { [unowned self] error in
            self.onCompletedLoading(error: error)
        }
    }
    
    private func checkForUpdates() {
        DataStore.shared.checkForUpdates { [unowned self] updated, error in
            if updated {
                self.initialSetup()
            } else {
                self.onCompletedLoading(error: error)
            }
        }
    }
    
    private func onCompletedLoading(error: Error?) {
        if let error = error {
            presentErrorView(error)
        } else {
            moveToTopPageView()
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
