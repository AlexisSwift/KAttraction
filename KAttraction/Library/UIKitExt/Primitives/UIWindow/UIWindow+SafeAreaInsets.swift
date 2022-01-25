import UIKit

public extension UIWindow {
    static let safeAreaInsets: UIEdgeInsets = {
        let window = UIApplication.shared.keyWindow
        if #available(iOS 11.0, *) {
            return window?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }()

    static let safeAreaBottomInset: CGFloat = {
        UIWindow.safeAreaInsets.bottom
    }()

    static let safeAreaTopInset: CGFloat = {
        UIWindow.safeAreaInsets.top
    }()
}
