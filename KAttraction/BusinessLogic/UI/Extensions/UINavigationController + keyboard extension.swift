import UIKit

extension UINavigationController {
    /// Call from a specific screen when a tap-to-dismiss-keyboard interaction is needed.
    /// The former global lifecycle override installed duplicate recognizers on every layout pass.
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
