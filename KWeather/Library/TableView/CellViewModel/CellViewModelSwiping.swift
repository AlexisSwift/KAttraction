import UIKit

@available(iOS 11.0, *)
public protocol CellViewModelTrailingSwiping {
    var contextualActions: [UIContextualAction] { get }
}

@available(iOS 11.0, *)
public protocol CellViewModelLeadingSwiping {
    var contextualActions: [UIContextualAction] { get }
}
