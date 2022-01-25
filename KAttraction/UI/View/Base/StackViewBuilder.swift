import UIKit.UIStackView

@resultBuilder
public enum StackViewBuilder {
    public static func buildBlock(_ args: UIView...) -> [UIView] {
        return args
    }
}

public extension UIStackView {

    convenience init(alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0, @StackViewBuilder content: () -> [UIView]) {
        self.init(arrangedSubviews: content().filter { !($0 is ZeroView) })
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
