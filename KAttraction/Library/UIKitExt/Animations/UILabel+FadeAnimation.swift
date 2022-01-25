import UIKit

public extension UILabel {
    func fadeTransition(text: String?, duration: CFTimeInterval = 0.4) {
        // Add Animation to label
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        layer.add(animation, forKey: "kCATransitionFade")
        // Change text after animation
        self.text = text
    }
}
