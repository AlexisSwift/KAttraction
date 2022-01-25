import UIKit

// swiftlint:disable final_class
open class ScrollStackView: UIScrollView {

    public var stackView: UIStackView!

    public var spacing: CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public convenience init(items: [UIView], axis: NSLayoutConstraint.Axis = .vertical) {
        self.init(frame: .zero)
        set(items: items)
        stackView.axis = axis
    }

    open func set(items: [UIView]) {
        clearStack()
        items.forEach { stackView.addArrangedSubview($0) }
    }

    open func add(item view: UIView) {
        createStackViewIfNeeded()
        stackView.addArrangedSubview(view)
    }

    open func setup() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        createStackViewIfNeeded()
    }

    private func clearStack() {
        stackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    private func createStackViewIfNeeded() {
        guard stackView == nil else {
            return
        }
        stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
    }

    override open func updateConstraints() {
        if #available(iOS 11.0, *) {
            let padding: CGFloat = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor, constant: padding),
                stackView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor, constant: -padding),
                stackView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor, constant: padding),
                stackView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor, constant: -padding)
            ])

            if stackView.axis == .horizontal {
                NSLayoutConstraint.activate([
                    stackView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor, constant: -padding * 2)
                ])
            } else {
                NSLayoutConstraint.activate([
                    stackView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, constant: -padding * 2)
                ])
            }
        } else {
            stackView.frame = bounds
            stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        super.updateConstraints()
    }
}
