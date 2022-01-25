import UIKit

public extension UIButton {
    func setTitleWithoutAnimation(_ title: String?) {
        UIView.performWithoutAnimation {
            setTitle(title, for: .normal)
            layoutIfNeeded()
        }
    }
}
