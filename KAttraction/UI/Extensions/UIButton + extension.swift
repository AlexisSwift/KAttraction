import Foundation
import UIKit
import RxSwift

public extension UIButton {
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.setTitle(title, for: .normal)
        return self
    }

    @discardableResult
    func setTitleColor(_ color: UIColor) -> Self {
        self.setTitleColor(color, for: .normal)
        return self
    }

    @discardableResult
    func setAttributedTitle(_ title: NSAttributedString?) -> Self {
        guard let title = title else { return self }
        self.setAttributedTitle(title, for: .normal)
        return self
    }

    @discardableResult
    func setTextAlignment(_ alignment: NSTextAlignment) -> Self {
        titleLabel?.textAlignment = alignment
        return self
    }

    @discardableResult
    func setContentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = alignment
        return self
    }

    @discardableResult
    func setContentVerticalAlignment(_ alignment: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = alignment
        return self
    }

    @discardableResult
    func setIsEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    @discardableResult
    func setLineBreakMode(_ mode: NSLineBreakMode) -> Self {
        titleLabel?.lineBreakMode = mode
        return self
    }

    @discardableResult
    func setTitleEdgeInset(_ inset: UIEdgeInsets) -> Self {
        titleEdgeInsets = inset
        return self
    }

    @discardableResult
    func touchUpInside(store: DisposeBag, _ action: @escaping ( () -> Void )) -> Self {
        self.rx.tap.asDriver()
            .drive { _ in
                action()
            }
            .disposed(by: store)
        return self
    }

    @discardableResult
    func setImage(_ image: UIImage?) -> Self {
        setImage(image, for: .normal)
        return self
    }

    @discardableResult
    func setFont(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
}
