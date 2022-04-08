import UIKit

public extension UIView {
    @objc convenience init(configurator: (UIView) -> Void) {
        self.init()
        configurator(self)
    }
}

public extension UILabel {
    convenience init(configurator: (UILabel) -> Void) {
        self.init()
        configurator(self)
    }
}

public extension UIButton {
    convenience init(configurator: (UIButton) -> Void) {
        self.init()
        configurator(self)
    }

    convenience init(type: UIButton.ButtonType, configurator: (UIButton) -> Void) {
        self.init(type: type)
        configurator(self)
    }
}

public extension UIImageView {
    convenience init(configurator: (UIImageView) -> Void) {
        self.init()
        configurator(self)
    }
}

public extension UIStackView {
    convenience init(configurator: (UIStackView) -> Void) {
        self.init()
        configurator(self)
    }

    convenience init(_ arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .vertical, configurator: ((UIStackView) -> Void)? = nil) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        configurator?(self)
    }
}

public extension UITextField {
    convenience init(configurator: (UITextField) -> Void) {
        self.init()
        configurator(self)
    }
}

public extension UITextView {
    convenience init(configurator: (UITextView) -> Void) {
        self.init()
        configurator(self)
    }
}

public extension UIRefreshControl {
    convenience init(configurator: (UIRefreshControl) -> Void) {
        self.init()
        configurator(self)
    }
}
