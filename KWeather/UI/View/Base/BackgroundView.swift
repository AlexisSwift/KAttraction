import SnapKit

@resultBuilder
public enum BackgroundViewBuilder {
    public static func buildBlock(_ arg: UIView) -> UIView {
        return arg
    }
}

// swiftlint:disable:next final_class
public class BackgroundView: BaseView {

    public convenience init(vPadding: CGFloat? = nil, hPadding: CGFloat? = nil,
                            @BackgroundViewBuilder content: () -> UIView) {
        self.init(frame: .zero)
        let subview = content()
        addSubview(subview)
        subview.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            if let hPadding = hPadding {
                maker.left.equalToSuperview().inset(hPadding)
                maker.right.equalToSuperview().inset(hPadding)
            }
            if let vPadding = vPadding {
                maker.top.equalToSuperview().inset(vPadding)
                maker.bottom.equalToSuperview().inset(vPadding)
            }
        }
    }

    public convenience init(left: CGFloat = 0,
                            right: CGFloat = 0,
                            top: CGFloat = 0,
                            bottom: CGFloat = 0,
                            @BackgroundViewBuilder content: () -> UIView) {
        self.init(frame: .zero)
        let subview = content()
        addSubview(subview)
        subview.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().inset(left)
            maker.top.equalToSuperview().inset(top)
            maker.right.equalToSuperview().inset(right)
            maker.bottom.equalToSuperview().inset(bottom)
        }
    }
}
