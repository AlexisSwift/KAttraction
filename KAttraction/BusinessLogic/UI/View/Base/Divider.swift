import SnapKit

// swiftlint:disable:next final_class
public class Divider: UIView {

    private let size: CGFloat

    public init(color: UIColor, size: CGFloat = 1) {
        self.size = size
        super.init(frame: .zero)

        background(color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()

        guard let axis = (superview as? UIStackView)?.axis else { return }
        switch axis {
        case .horizontal:
            snp.makeConstraints { (maker) in
                maker.width.equalTo(size)
                maker.height.equalToSuperview()
            }
        case .vertical:
            snp.makeConstraints { (maker) in
                maker.width.equalToSuperview()
                maker.height.equalTo(size)
            }
        default:
            break
        }
    }
}
