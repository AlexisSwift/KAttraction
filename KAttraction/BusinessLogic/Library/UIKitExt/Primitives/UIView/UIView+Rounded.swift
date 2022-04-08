import UIKit

public extension UIView {
    @discardableResult
    func roundCorners(corners: UIRectCorner, radius: CGFloat) -> UIView {
        let path: UIBezierPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask: CAShapeLayer = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask

        return self
    }
}
