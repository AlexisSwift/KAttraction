import UIKit

public extension UICollectionView {
    var isEmpty: Bool {
        if numberOfSections == 0 {
            return true
        }
        return (0...numberOfSections - 1)
            .map(numberOfItems(inSection:))
            .reduce(0, +) == 0
    }

    var isNotEmpty: Bool {
        guard numberOfSections > 0 else {
            return false
        }
        for item in 0 ... (numberOfSections - 1) {
            if numberOfItems(inSection: item) > 0 {
                return true
            }
        }
        return false
    }
}
