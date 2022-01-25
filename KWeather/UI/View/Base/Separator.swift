import UIKit
import RxSwift

// swiftlint:disable final_class modifier_order
open class Separator: UIView {
    public typealias Views = (container: UIView, separator: UIView)
    public typealias Configurator = (Views) -> Void

    public enum Status {
        case active
        case inactive
        case error
    }

    public enum Alignment {
        case vertical
        case horizontal
    }

    public var thickness: CGFloat = 1
    private var insets: UIEdgeInsets = .zero
    private var separatorStatus: Status = .inactive
    private var configurator: Configurator?
    private let disposeBag = DisposeBag()

    let insideSeparator = UIView()

    init(alignment: Alignment) {
        super.init(frame: .zero)
        setSize(alignment: alignment)
    }

    public convenience init(
        alignment: Alignment,
        separatorStatus: Status
    ) {
        self.init(alignment: alignment)
        self.separatorStatus = separatorStatus
    }

    public convenience init(
        alignment: Alignment,
        thickness: CGFloat = 1 / UIScreen.main.scale,
        insets: UIEdgeInsets,
        configurator: Configurator? = nil
    ) {
        self.init(alignment: alignment)
        self.thickness = thickness
        self.configurator = configurator
        self.insets = insets
        setup()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(thickness: CGFloat) {
        self.thickness = thickness
    }

    public func set(insets: UIEdgeInsets) {
        self.insets = insets
    }

    public func set(configurator: Configurator?) {
        self.configurator = configurator
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            configurator?((container: self, separator: insideSeparator))
        }
    }

    private func setSize(alignment: Alignment) {
        switch alignment {
        case .horizontal:
            height(thickness)
        case .vertical:
            width(thickness)
        }
    }

    open func setup() {
        backgroundColor = .clear
        addSubview(insideSeparator)
        insideSeparator.embedInWithInsets(
            self,
            left: insets.left,
            top: insets.top,
            right: insets.right,
            bottom: insets.bottom
        )
    }
}
