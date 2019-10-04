import UIKit

class TopPageViewController: UIPageViewController {
    
    var pageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let launchScanningViewController = LaunchScanningViewController.loadViewControllerFromStoryboard()
        self.setViewControllers([launchScanningViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension TopPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is WorkCollectionViewController {
            pageIndex = 0
            return LaunchScanningViewController.loadViewControllerFromStoryboard()
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is LaunchScanningViewController {
            pageIndex = 1
            return WorkCollectionViewController.loadViewControllerFromStoryboard()
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
