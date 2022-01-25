import UIKit

public extension UIView {
    private func alphaAnimation(to alpha: CGFloat) -> () -> Void {
        return { [weak self] in
            self?.alpha = alpha
        }
    }

    private func moveAnimation(x: CGFloat, y: CGFloat) -> () -> Void {
        return { [weak self] in
            self?.transform = CGAffineTransform.identity.translatedBy(x: x, y: y)
        }
    }

    func identityTransformAnimation() -> () -> Void {
        return { [weak self] in
            self?.transform = CGAffineTransform.identity
        }
    }

    private func wrapped(completion: (() -> Void)?) -> ((Bool) -> Void)? {
        guard let completion = completion else {
            return nil
        }
        return { _ in
            completion()
        }
    }
}

public extension UIView {
    func fadeIn(duration: TimeInterval? = 0.2,
                delay: TimeInterval = 0,
                then: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? 0,
                       delay: delay,
                       animations: alphaAnimation(to: 1),
                       completion: wrapped(completion: then))
    }

    func fadeOut(duration: TimeInterval? = 0.2,
                 delay: TimeInterval = 0,
                 then: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? 0,
                       delay: delay,
                       animations: alphaAnimation(to: 0),
                       completion: wrapped(completion: then))
    }

    func moveHorizontally(distance: CGFloat,
                          duration: TimeInterval? = 0.2,
                          delay: TimeInterval = 0,
                          then: (() -> Void)? = nil) {
        move(
            distanceX: distance,
            distanceY: 0,
            duration: duration,
            delay: delay,
            then: then
        )
    }

    func moveVertically(distance: CGFloat,
                        duration: TimeInterval? = 0.2,
                        delay: TimeInterval = 0,
                        then: (() -> Void)? = nil) {
        move(
            distanceX: 0,
            distanceY: distance,
            duration: duration,
            delay: delay,
            then: then
        )
    }

    func move(distanceX: CGFloat,
              distanceY: CGFloat,
              duration: TimeInterval? = 0.2,
              delay: TimeInterval = 0,
              then: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? 0,
                       delay: delay,
                       animations: moveAnimation(x: distanceX, y: distanceY),
                       completion: wrapped(completion: then))
    }

    func restoreTransform(duration: TimeInterval? = 0.2,
                          delay: TimeInterval = 0,
                          then: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration ?? 0,
            delay: delay,
            animations: identityTransformAnimation(),
            completion: wrapped(completion: then)
        )
    }

    func toogleHideWithAnimation(isHidden: Bool) {
        guard superview is UIStackView else { return }

        isHidden ? self.fadeOut() : self.fadeIn()

        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            animations: { [weak self] in
                self?.isHidden = isHidden
            }
        )
    }
}
