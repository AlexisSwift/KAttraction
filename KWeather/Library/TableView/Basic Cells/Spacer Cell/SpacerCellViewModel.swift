import UIKit

// swiftlint:disable final_class
open class SpacerCellViewModel: CellViewModelFaceless, CellViewModelHeightable, Hashable {
    public typealias Configurator = (CellType) -> Void

    public let height: CGFloat
    private let identifier = UUID()

    private let configurator: Configurator?

    public init(height: CGFloat = 1 / UIScreen.main.scale, configurator: Configurator? = nil) {
        self.height = height
        self.configurator = configurator
    }

    open func configure(cell: UITableViewCell) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        configurator?(cell)
    }

    public static func == (lhs: SpacerCellViewModel, rhs: SpacerCellViewModel) -> Bool {
        return lhs.height == rhs.height && lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
