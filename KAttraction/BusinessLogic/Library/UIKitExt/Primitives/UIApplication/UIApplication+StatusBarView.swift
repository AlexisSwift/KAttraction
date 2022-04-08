import UIKit

public extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            // FIXME
            // https://freakycoder.com/ios-notes-13-how-to-change-status-bar-color-1431c185e845
            return nil
        } else {
            return value(forKey: "statusBar") as? UIView
        }
    }
}
