import UIKit

open class Button: UIButton {
    public convenience init(title: String?) {
        self.init(type: .system)
        setTitle(title, for: .normal)
    }

    public convenience init(image: UIImage?) {
        self.init(type: .system)
        setImage(image, for: .normal)
    }
}
