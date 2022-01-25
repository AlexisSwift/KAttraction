import UIKit

public extension UIStackView {
    func set(arrangedSubviews subviews: [UIView]) {
        removeArrangedSubviews()
        add(arrangedSubviews: subviews)
    }

    func set(arrangedSubviews subviews: [UIView?]) {
        removeArrangedSubviews()
        add(arrangedSubviews: subviews)
    }

    func add(arrangedSubviews subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }

    func add(arrangedSubviews subviews: [UIView?]) {
        subviews.compactMap { $0 }.forEach { addArrangedSubview($0) }
    }

    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
            removeArrangedSubview($0)
        }
    }

    func add(arrangedSubview subview: UIView?) {
        subview.flatMap(addArrangedSubview)
    }

    func child<T>(_ type: T.Type) -> T? {
        arrangedSubviews.first(where: { $0 is T }) as? T
    }
}
