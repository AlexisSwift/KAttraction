import UIKit

public extension UITableView {
    var isEmpty: Bool {
        if numberOfSections == 0 {
            return true
        }
        return (0...numberOfSections - 1)
            .map(numberOfRows(inSection:))
            .reduce(0, +) == 0
    }

    var isNotEmpty: Bool {
        guard numberOfSections > 0 else {
            return false
        }
        for item in 0 ... (numberOfSections - 1) where numberOfRows(inSection: item) > 0 {
            return true
        }
        return false
    }

    func selectAll(animated: Bool) {
        (0..<numberOfSections).compactMap { (section) -> [IndexPath]? in
            return (0..<numberOfRows(inSection: section)).compactMap({ (item) -> IndexPath? in
                print(IndexPath(item: item, section: section))
                return IndexPath(item: item, section: section)
            })
        }.flatMap { $0 }.forEach { (indexPath) in
            selectRow(at: indexPath, animated: animated, scrollPosition: .none)
        }
    }

    /// Deselects all selected cells.
    func deselectAll(animated: Bool) {
        indexPathsForSelectedRows?.forEach({ (indexPath) in
            deselectRow(at: indexPath, animated: animated)
        })
    }
}
