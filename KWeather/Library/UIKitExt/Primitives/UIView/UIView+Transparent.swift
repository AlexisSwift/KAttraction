import UIKit

// swiftlint:disable vertical_parameter_alignment_on_call
public extension UIView {
    /// Cuts a transparent hole in the view
    func cut(view: UIView, cornerRadius: CGFloat = 0.0) {
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = frame
        maskLayer.fillColor = UIColor.black.cgColor

        let path: UIBezierPath = UIBezierPath(rect: bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        let rect: CGRect = CGRect(x: view.frame.minX + 4,
                          y: view.frame.minY,
                          width: view.bounds.width - 8,
                          height: view.bounds.height)

        path.append(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    /// Reset the current layer settings
    func flushLayers() {
        layer.sublayers = []
    }

    func withAlpha(value: CGFloat = 0.0) -> Self {
        self.alpha = value
        return self
    }
}
