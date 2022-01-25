import UIKit

public protocol CollectionCellViewModelDisplayable {
    func onWillDisplayAnyModel(cell: UICollectionViewCell)
    func onDidEndDisplayingAnyModel(cell: UICollectionViewCell)
}

public protocol CollectionCellViewModelDisplayableFaceless: CollectionCellViewModelDisplayable {
    var onWillDisplay: ((_ model: Self, _ cell: UICollectionViewCell) -> Void)? { get set }
    var onDidEndDisplaying: ((_ model: Self, _ cell: UICollectionViewCell) -> Void)? { get set }
}

public extension CollectionCellViewModelDisplayableFaceless {
    func onWillDisplayAnyModel(cell: UICollectionViewCell) {
        onWillDisplay?(self, cell)
    }

    func onDidEndDisplayingAnyModel(cell: UICollectionViewCell) {
        onDidEndDisplaying?(self, cell)
    }
}
