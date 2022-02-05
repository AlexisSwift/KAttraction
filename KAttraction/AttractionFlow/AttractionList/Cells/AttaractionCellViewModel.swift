import UIKit

final class AttaractionCellViewModel: CellViewModelFaceless, CellViewModelHeightable {
    
    typealias CellType = AttaractionCell
    
    var height: CGFloat = UITableView.automaticDimension
    var source: AttaractionCell.AttractionConfig
    var onDetailAttractionsScreen: StringHandler?
    
    init(source: AttaractionCell.AttractionConfig) {
        self.source = source
    }
    
    func configure(cell: AttaractionCell) {
        cell.set(model: source)
        cell.onDetails = onDetailAttractionsScreen
    }
}
