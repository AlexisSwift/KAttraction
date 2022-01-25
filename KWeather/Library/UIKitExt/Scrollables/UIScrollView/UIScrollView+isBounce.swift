import UIKit

extension UIScrollView {
    var isTopBounce: Bool {
        return contentOffset.y < 0
    }

    var isNotTopBounce: Bool {
        return !isTopBounce
    }

    var isBottomBounce: Bool {
        var overSize = contentSize.height - bounds.size.height
        overSize = max(overSize, 0.0)
        return contentOffset.y > overSize
    }

    var isNotBottomBounce: Bool {
        return !isBottomBounce
    }

    var isVerticalBounce: Bool {
        return isTopBounce || isBottomBounce
    }

    var isNotVerticalBounce: Bool {
        return !isVerticalBounce
    }

    var isLeftBounce: Bool {
        return contentOffset.x < 0
    }

    var isNotLeftBounce: Bool {
        return !isLeftBounce
    }

    var isRightBounce: Bool {
        return contentOffset.x > (contentSize.width - bounds.size.width)
    }

    var isNotRightBounce: Bool {
        return !isRightBounce
    }

    var isHorizontalBounce: Bool {
        return isLeftBounce || isRightBounce
    }

    var isNotHorizontalBounce: Bool {
        return !isHorizontalBounce
    }

    var isBounce: Bool {
        return isVerticalBounce || isHorizontalBounce
    }

    var isNotBounce: Bool {
        return !isBounce
    }
}
