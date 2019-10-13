import UIKit

class TopPageViewController: UIPageViewController {
    
    var pageIndex: Int = 0
    lazy var pageViewControllers = [
        LaunchScanningViewController.loadViewControllerFromStoryboard(),
        HistoryViewController.init()
    ]
    
    enum PageInstance: Int {
        case launchScanningViewController = 0
        case workCollectionViewController = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        showPage(.launchScanningViewController)
    }
    
    func showPage(_ instance: PageInstance) {
        let viewController = pageViewControllers[instance.rawValue]
        self.pageIndex = instance.rawValue
        
        switch instance {
        case .launchScanningViewController:
            self.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
            
        case .workCollectionViewController:
            self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension TopPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is HistoryViewController {
            pageIndex = 0
            return pageViewControllers[pageIndex] // launchScanningViewController
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is LaunchScanningViewController {
            pageIndex = 1
            return pageViewControllers[pageIndex] // workCollectionViewController
        } else {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pageIndex
    }
}

extension TopPageViewController: UIPageViewControllerDelegate {
    
}
