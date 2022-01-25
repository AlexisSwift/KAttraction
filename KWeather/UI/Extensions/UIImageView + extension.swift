import Foundation
import UIKit

public extension UIImageView {
    @discardableResult
    func contentMode(_ contentMode: UIImageView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
}
