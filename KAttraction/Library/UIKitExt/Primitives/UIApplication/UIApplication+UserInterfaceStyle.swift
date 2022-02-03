import UIKit

public extension UIApplication {
    @available(iOS 13.0, *)
    var userInterfaceStyle: UIUserInterfaceStyle? {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
}
