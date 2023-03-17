import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Context {
        case present
        case dismiss
    }

    private let context: Context
    
    init(context: Context) {
        self.context = context
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return context == .present ? 0.3 : 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                fromView.alpha = 0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromView.alpha = 1
        }
    }
}
