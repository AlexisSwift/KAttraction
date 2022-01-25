import UIKit

public extension UILabel {
    func change(text: String?, withDuration duration: TimeInterval) {
        fadeOut(duration: duration) { [weak self] in
            self?.text = text
            self?.fadeIn(duration: duration)
        }
    }

    func change(custom: @escaping (UILabel?) -> Void, withDuration duration: TimeInterval) {
        fadeOut(duration: duration) { [weak self] in
            custom(self)
            self?.fadeIn(duration: duration)
        }
    }
}
