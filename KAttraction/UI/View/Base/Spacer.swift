import UIKit

public final class Spacer: BaseView {

    let size: CGSize

    override public var intrinsicContentSize: CGSize { size }

    init(size: CGSize) {
        self.size = size
        super.init(frame: CGRect(origin: .zero, size: size))
    }

    public required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        size = .zero
        super.init(frame: .zero)
    }

    convenience init() {
        self.init(size: .zero)
    }

    public convenience init(height: CGFloat) {
        self.init(size: .init(width: UIView.noIntrinsicMetric, height: height))
        snp.makeConstraints { $0.height.equalTo(height) }
    }

    public convenience init(width: CGFloat) {
        self.init(size: .init(width: width, height: UIView.noIntrinsicMetric))
        snp.makeConstraints { $0.width.equalTo(width) }
    }

    override public func setup() {
        super.setup()
        backgroundColor = .clear
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)

        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
}

// swiftlint:disable final_class
public class FlexibleSpacer: BaseView {

    public convenience init(matchingHeightOf matchView: UIView, withMultiplier multiplier: CGFloat) {
        self.init()
        self.snp.makeConstraints { $0.height.equalTo(matchView).multipliedBy(multiplier) }
    }

    public convenience init(minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        self.init()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        if let minHeight = minHeight {
            self.snp.makeConstraints { $0.height.greaterThanOrEqualTo(minHeight) }
        }
        if let maxHeight = maxHeight {
            self.snp.makeConstraints { $0.height.lessThanOrEqualTo(maxHeight).priority(.low) }
        }
    }

    public convenience init(minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil) {
        self.init()
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        if let minWidth = minWidth {
            self.snp.makeConstraints { $0.width.greaterThanOrEqualTo(minWidth) }
        }
        if let maxWidth = maxWidth {
            self.snp.makeConstraints { $0.width.lessThanOrEqualTo(maxWidth).priority(.low) }
        }
    }

    override public func setup() {
        super.setup()

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .vertical)
    }
}

/// Flexible spacer, which creates a group along with other spacers with the same `groupId`. BaseStackView would make equal height/width constraints according to stack view axis
public final class FlexibleGroupedSpacer: FlexibleSpacer {

    let groupId: UInt

    public init(groupId: UInt) {
        self.groupId = groupId
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        groupId = 0
        super.init(frame: .zero)
    }
}
