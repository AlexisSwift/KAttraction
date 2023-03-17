import UIKit.UIStackView

// swiftlint:disable:next final_class
open class BaseStackView: UIStackView {

    private let backgroundView = BaseView()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public convenience init(_ arrangedSubviews: [UIView] = [], configurator: ((BaseStackView) -> Void)? = nil) {
        self.init()
        arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            linkSpacers()
            addArrangedSubview($0)
        }
        configurator?(self)
    }

    @discardableResult
    public func linkSpacers() -> Self {
        let linkedSpacers: [FlexibleGroupedSpacer] = arrangedSubviews.compactMap { subview in
            if let linkedSpacer = subview as? FlexibleGroupedSpacer {
                return linkedSpacer
            }
            return nil
        }

        Dictionary(grouping: linkedSpacers) { $0.groupId }.forEach { _, spacerGroup in
            if spacerGroup.count < 2 {
                return
            }
            for idx in (0..<spacerGroup.count - 1) {
                let spacer = spacerGroup[idx]
                let nextSpacer = spacerGroup[idx + 1]
                switch axis {
                case .vertical:
                    spacer.snp.makeConstraints { (maker) in
                        maker.height.equalTo(nextSpacer)
                    }
                case .horizontal:
                    spacer.snp.makeConstraints { (maker) in
                        maker.width.equalTo(nextSpacer)
                    }
                @unknown default:
                    break
                }
            }
        }
        return self
    }

    open func setup() {
        backgroundView.embedIn(self)
    }

    override public func background(_ color: UIColor?) -> Self {
        backgroundView.background(color)
        return self
    }

    override public func cornerRadius(_ radius: CGFloat) -> Self {
        backgroundView.cornerRadius(radius)
        return self
    }

    override public func border(width: CGFloat = 1, color: UIColor) -> Self {
        backgroundView.border(width: width, color: color)
        return self
    }

    override public func roundingCorners(corners: CACornerMask, radius: CGFloat) -> Self {
        backgroundView.roundingCorners(corners: corners, radius: radius)
        return self
    }

    @discardableResult
    public func layoutMargins(
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        bottom: CGFloat? = nil,
        right: CGFloat? = nil
    ) -> Self {
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(
            top: top ?? self.layoutMargins.top,
            left: left ?? self.layoutMargins.left,
            bottom: bottom ?? self.layoutMargins.bottom,
            right: right ?? self.layoutMargins.right
        )
        return self
    }

    @discardableResult
    public func layoutMargins(
        vInset: CGFloat? = nil,
        hInset: CGFloat? = nil
    ) -> Self {
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(
            top: vInset ?? self.layoutMargins.top,
            left: hInset ?? self.layoutMargins.left,
            bottom: vInset ?? self.layoutMargins.bottom,
            right: hInset ?? self.layoutMargins.right
        )
        return self
    }

    @discardableResult
    public func layoutMargins(inset: CGFloat) -> Self {
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
        return self
    }

    @discardableResult
    public func layoutMarginsRelativeArrangement(_ isLayoutMarginsRelativeArrangement: Bool) -> Self {
        self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        return self
    }
}

// swiftlint:disable:next final_class
public class HStack: BaseStackView {

    override public func setup() {
        super.setup()
        axis = .horizontal
    }
}
// swiftlint:disable:next final_class
public class VStack: BaseStackView {

    override public func setup() {
        super.setup()
        axis = .vertical
    }
}
