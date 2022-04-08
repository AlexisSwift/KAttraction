import UIKit

public extension UIWindow {
    static let safeAreaInsets: UIEdgeInsets = {
        UIWindow.safeAreaInsets
    }()

    static let safeAreaBottomInset: CGFloat = {
        UIWindow.safeAreaInsets.bottom
    }()

    static let safeAreaTopInset: CGFloat = {
        UIWindow.safeAreaInsets.top
    }()
}
