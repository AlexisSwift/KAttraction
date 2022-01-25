import UIKit

/// Indicates the ability of the entity to participate in navigation
public protocol Presentable: AnyObject {
    func toPresent() -> UIViewController?
    func removeFromParentIfNeeded()
}

extension UIViewController: Presentable {
    public func toPresent() -> UIViewController? {
        return self
    }

    public func removeFromParentIfNeeded() {
        view.fadeOut { [weak self] in
            self?.removeFromParent()
            self?.view.removeFromSuperview()
        }
    }
}
