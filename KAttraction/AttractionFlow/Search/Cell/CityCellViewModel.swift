import UIKit

final class CityCellViewModel: CellViewModelFaceless, CellViewModelHeightable {
    
    typealias CellType = CityCell
    
    var height: CGFloat = UITableView.automaticDimension
    
    var source: City
    
    var attractionHandler: CityHandler?
    
    init(source: City, handler: CityHandler?) {
        self.source = source
        self.attractionHandler = handler
    }
    
    func configure(cell: CityCell) {
        cell.set(model: source, handler: attractionHandler)
    }
}
