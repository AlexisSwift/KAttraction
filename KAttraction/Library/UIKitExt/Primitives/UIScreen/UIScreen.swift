import UIKit

public extension UIScreen {
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }

    static var width: CGFloat {
        return size.width
    }

    static var height: CGFloat {
        return size.height
    }
}
