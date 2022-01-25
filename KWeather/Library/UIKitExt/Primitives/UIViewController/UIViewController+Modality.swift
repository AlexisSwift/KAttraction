import UIKit

public extension UIViewController {
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentedVC = navigationController?.presentingViewController?.presentedViewController
        let presentingIsNavigation = presentedVC == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
}
