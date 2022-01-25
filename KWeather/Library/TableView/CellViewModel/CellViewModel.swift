import UIKit

public protocol CellViewModel {
    static var cellAnyType: UIView.Type { get }
    static var loadsFromNib: Bool { get }
    func configureAny(cell: UIView)
}

public protocol CellViewModelFaceless: CellViewModel {
    associatedtype CellType: UIView
    func configure(cell: CellType)
}

public extension CellViewModelFaceless {
    static var cellAnyType: UIView.Type {
        return CellType.self
    }

    static var loadsFromNib: Bool {
        return false
    }

    func configureAny(cell: UIView) {
        if let cell = cell as? CellType {
            configure(cell: cell)
        } else {
            assertionFailure("CellViewModelFaceless and be implemet UIView and subclass only")
        }
    }
}
