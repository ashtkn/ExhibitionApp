import UIKit

protocol StoryboardInitializable {}

extension StoryboardInitializable where Self: UIViewController {
    static func loadViewControllerFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Can not load ViewController")
        }
        return viewController
    }
    
    static func loadNavigationControllerFromStoryboard() -> UINavigationController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Can not load NavigationController")
        }
        return navigationController
    }
}

// with inject dependency
extension StoryboardInitializable where Self: UIViewController, Self: Injectable {
    static func loadViewControllerFromStoryboard(with dependency: Self.Dependency) -> Self {
        var viewController = loadViewControllerFromStoryboard()
        viewController.dependency = dependency
        return viewController
    }
}

extension UIViewController: StoryboardInitializable {}
