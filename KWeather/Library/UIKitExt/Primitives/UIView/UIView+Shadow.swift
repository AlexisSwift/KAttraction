import UIKit

public extension UIView {
    func setShadow(radius: CGFloat,
                   color: UIColor,
                   offsetX: CGFloat = 0,
                   offsetY: CGFloat = 0) {
        layer.setShadow(radius: radius,
                        color: color,
                        offsetX: offsetX,
                        offsetY: offsetY)
    }

    func removeShadow() {
        layer.removeShadow()
    }
}

public extension CALayer {
    func setShadow(radius: CGFloat,
                   color: UIColor,
                   offsetX: CGFloat = 0,
                   offsetY: CGFloat = 0) {
        shadowOpacity = 1
        shadowColor = color.cgColor
        shadowRadius = CGFloat(radius)
        shadowOffset = CGSize(width: offsetX,
                              height: offsetY)
    }

    func removeShadow() {
        shadowOpacity = 0
        shadowRadius = 0
        shadowOffset = .zero
    }
}

final class ShadowLayer: CALayer {
    public convenience init(shadowRadius: CGFloat,
                            shadowColor: UIColor,
                            shadowOffsetX: CGFloat = 0,
                            shadowOffsetY: CGFloat = 0) {
        self.init()
        setShadow(radius: shadowRadius,
                  color: shadowColor,
                  offsetX: shadowOffsetX,
                  offsetY: shadowOffsetY)
    }
}
