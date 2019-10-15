import UIKit

final class LoadingViewController: UIViewController {

    // TODO: もし新しい作品があれば情報をアップデートする
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataStore.shared.hasCompletedSetup {
            moveToTopPageView()
        } else {
            setup()
        }
    }
    
    private func setup() {
        DataStore.shared.createNewUserData()
        
        print("Start downloading") // TODO: Show indicator
        DataStore.shared.downloadFiles { [unowned self] error in
            if let error = error {
                self.presentErrorView(error)
            } else {
                print("Finish downloading") // TODO: Dismiss indicator
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
        print("\(error)")
    }
}
