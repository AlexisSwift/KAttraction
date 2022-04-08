import UIKit

public extension UIWindow {
    func getCurrentTopmostViewController(
        _ controller: UIViewController? = nil
    ) -> UIViewController? {
        let inputController = (controller == nil) ? rootViewController : controller

        if let navigationController = inputController as? UINavigationController {
            return getCurrentTopmostViewController(navigationController.visibleViewController)
        }
        if let tabController = inputController as? UITabBarController,
            let selected = tabController.selectedViewController {
            return getCurrentTopmostViewController(selected)
        }
        if let presented = inputController?.presentedViewController {
            return getCurrentTopmostViewController(presented)
        }
        return inputController
    }
}
