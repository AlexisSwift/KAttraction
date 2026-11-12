import UIKit

/// A blur view implemented exclusively with public UIKit APIs.
open class VisualEffectView: UIVisualEffectView {
    private let visibleEffect: UIVisualEffect

    public init(style: UIBlurEffect.Style = .systemMaterial) {
        visibleEffect = UIBlurEffect(style: style)
        super.init(effect: nil)
    }

    public required init?(coder: NSCoder) {
        visibleEffect = UIBlurEffect(style: .systemMaterial)
        super.init(coder: coder)
    }

    open func show() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.effect = self?.visibleEffect
        }
    }

    open func hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.effect = nil
        }, completion: { finished in
            if finished {
                completion()
            }
        })
    }
}
