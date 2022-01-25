import UIKit

public extension UILabel {
    var multilined: Self {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        return self
    }
}

public extension UIView {
    var withoutAutoresizingMaskTranslation: Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func addSubview(_ subview: UIView, completion: (UIView) -> Void) {
        addSubview(subview)
        completion(subview)
    }
}

public extension UIStackView {
    func addArrangedSubview(_ subview: UIView, completion: (UIView) -> Void) {
        addArrangedSubview(subview)
        completion(subview)
    }
}
