import UIKit

final class AttaractionCellViewModel: CellViewModelFaceless, CellViewModelHeightable {
    
    typealias CellType = AttaractionCell
    
    var height: CGFloat = UITableView.automaticDimension
    
    // MARK: - Handler
    private let onDetailAttractionsScreen: StringHandler?
    
    // MARK: - model
    private let source: AttaractionCell.AttractionConfig
    
    init(source: AttaractionCell.AttractionConfig, handler: StringHandler?) {
        self.source = source
        self.onDetailAttractionsScreen = handler
    }
    
    func configure(cell: AttaractionCell) {
        cell.set(model: source)
        cell.onDetails = onDetailAttractionsScreen
    }
}
