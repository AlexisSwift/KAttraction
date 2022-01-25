import UIKit

// swiftlint:disable final_class
@IBDesignable
open class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }

    open func set(gradient: Gradient?) {
        guard let gradient = gradient else {
            return
        }
        gradientLayer?.startPoint = gradient.direction.startPoint
        gradientLayer?.endPoint = gradient.direction.endPoint
        gradientLayer?.colors = gradient.colors.map { $0.cgColor }
    }
}
