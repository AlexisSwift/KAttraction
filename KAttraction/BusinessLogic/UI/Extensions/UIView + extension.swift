import SnapKit
import RxSwift
import RxCocoa

public extension UIView {
    /// View itself with disabled autoresizing mask translation
    var deferredAutolayout: Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func embed(subview: UIView) -> Self {
        addSubview(subview)
        subview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return self
    }

    convenience init(color: UIColor) {
        self.init(frame: .zero)
        background(color)
    }

    @discardableResult
    func embedIn(_ any: UIView, hInset: CGFloat = .zero, vInset: CGFloat = .zero) -> Self {
        any.removeSubviews()
        any.addSubview(self)
        snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(hInset)
            $0.top.bottom.equalToSuperview().inset(vInset)
        }
        return self
    }

    @discardableResult
    func embedIn(_ any: UIView, inset: CGFloat = .zero) -> Self {
        any.removeSubviews()
        any.addSubview(self)
        snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
        return self
    }

    @discardableResult
    func putInCenter(of any: UIView) -> Self {
        any.addSubview(self)
        snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return self
    }

    @discardableResult
    func embedInWithSafeArea(_ any: UIView, hInset: CGFloat = .zero, vInset: CGFloat = .zero) -> Self {
        any.removeSubviews()
        any.addSubview(self)
        snp.makeConstraints { (maker) in
            guard let superview = superview else { return }
            maker.left.equalToSuperview().inset(hInset)
            maker.right.equalToSuperview().inset(hInset)
            maker.top.equalTo(superview.safeAreaLayoutGuide).inset(vInset)
            maker.bottom.equalTo(superview.safeAreaLayoutGuide).inset(vInset)
        }
        return self
    }

    @discardableResult
    func embedInWithInsets(_ any: UIView, left: CGFloat = .zero, top: CGFloat = .zero,
                           right: CGFloat = .zero, bottom: CGFloat = .zero) -> Self {
        any.addSubview(self)
        snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().inset(left)
            maker.top.equalToSuperview().inset(top)
            maker.right.equalToSuperview().inset(right)
            maker.bottom.equalToSuperview().inset(bottom)
        }
        return self
    }

    @discardableResult
    func onTap(store: DisposeBag, action: @escaping (() -> Void)) -> Self {
        let tapGesture = UITapGestureRecognizer()

        tapGesture.rx
            .observe(\.state, options: .new)
            .filter({ $0 == .ended })
            .bind(onNext: { _ in
                action()
            })
            .disposed(by: store)
        addGestureRecognizer(tapGesture)
        return self
    }

    @discardableResult
    func height(_ value: CGFloat) -> Self {
        snp.makeConstraints { (maker) in
            maker.height.equalTo(value)
        }
        return self
    }

    @discardableResult
    func heightGreaterOrEqual(_ value: CGFloat) -> Self {
        snp.makeConstraints { (maker) in
            maker.height.greaterThanOrEqualTo(value)
        }
        return self
    }

    @discardableResult
    func heightLessOrEqual(_ value: CGFloat) -> Self {
        snp.makeConstraints { (maker) in
            maker.height.lessThanOrEqualTo(value)
        }
        return self
    }

    @discardableResult
    func width(_ value: CGFloat) -> Self {
        snp.makeConstraints { (maker) in
            maker.width.equalTo(value)
        }
        return self
    }

    @discardableResult
    func widthGreaterOrEqual(_ value: CGFloat) -> Self {
        snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(value)
        }
        return self
    }

    @discardableResult
    func widthLessOrEqual(_ value: CGFloat) -> Self {
        snp.makeConstraints { (maker) in
            maker.width.lessThanOrEqualTo(value)
        }
        return self
    }

    @discardableResult
    func size(_ value: CGSize) -> Self {
        snp.makeConstraints { (maker) in
            maker.size.equalTo(value)
        }
        return self
    }

    @discardableResult @objc
    func cornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        clipsToBounds = true
        return self
    }

    @discardableResult
    func clipToBounds() -> Self {
        clipsToBounds = true
        layer.masksToBounds = true
        return self
    }

    @discardableResult @objc
    func roundingCorners(corners: CACornerMask, radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        return self
    }

    @discardableResult @objc
    func background(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    func huggingPriority(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        setContentHuggingPriority(priority, for: axis)
        return self
    }

    @discardableResult
    func compressionResistance(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        setContentCompressionResistancePriority(priority, for: axis)
        return self
    }

    @discardableResult @objc
    func border(width: CGFloat = 1, color: UIColor) -> Self {
        self.borderColor = color
        self.borderWidth = width
        return self
    }

    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func removeFromStackWithAnimation() {
        guard superview is UIStackView else { return }
        self.alpha = 0
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.isHidden = true
                       },
                       completion: { [weak self] _ in self?.removeFromSuperview() })
    }

    @discardableResult
    func userInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    @discardableResult
    func isHidden(toggle: Driver<Bool>, store: DisposeBag) -> Self {
        toggle
            .drive(onNext: { [weak self] isHidden in
                self?.isHidden = isHidden
            })
            .disposed(by: store)
        return self
    }

    func animateCornerRadius(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        CATransaction.begin()
        let animationKey = "cornerRadius"

        let cornersAnimation = CABasicAnimation(keyPath: animationKey)
        cornersAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        cornersAnimation.fromValue = from
        cornersAnimation.toValue = to
        cornersAnimation.duration = duration

        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.cornerRadius = to
        }

        layer.add(cornersAnimation, forKey: animationKey)
        CATransaction.commit()
    }
}
