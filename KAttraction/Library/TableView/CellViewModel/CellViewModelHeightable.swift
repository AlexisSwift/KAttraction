import UIKit

public protocol CellViewModelHeightable {
    var height: CGFloat { get }
}

public protocol CellViewModelSizeable {
    var size: CGSize { get }
}

public protocol CellViewModelItemSpacing {
    var itemSpacing: CGFloat { get }
}
