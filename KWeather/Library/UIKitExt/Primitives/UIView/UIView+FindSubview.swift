import UIKit

// swiftlint:disable final_class
public extension UIView {
    func findSubview(ofType classType: AnyClass) -> UIView? {
        for subview in self.subviews {
            if subview.isKind(of: classType) {
                return subview
            }
        }
        return nil
    }
}
