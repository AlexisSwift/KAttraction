import UIKit

public extension UITableView {
    func dequeueReusableCell(withModel model: CellViewModel, for indexPath: IndexPath) -> UITableViewCell {
        let indetifier = String(describing: type(of: model).cellAnyType)
        let cell = dequeueReusableCell(withIdentifier: indetifier, for: indexPath)
        model.configureAny(cell: cell)
        return cell
    }

    func register(cells models: [CellViewModel.Type]) {
        for model in models {
            let identifier = String(describing: model.cellAnyType)
            if model.loadsFromNib {
                let bundle = Bundle(for: model.cellAnyType)
                let nib = UINib(nibName: identifier, bundle: bundle)
                register(nib, forCellReuseIdentifier: identifier)
            } else {
                register(model.cellAnyType, forCellReuseIdentifier: identifier)
            }
        }
    }
}

public extension UITableView {
    func dequeueReusableHeaderFooterView(withModel model: CellViewModel) -> UITableViewHeaderFooterView? {
        let indetifier = String(describing: type(of: model).cellAnyType)
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: indetifier) else {
            return nil
        }
        model.configureAny(cell: cell)
        return cell
    }

    func register(headerFooterModels models: [CellViewModel.Type]) {
        for model in models {
            let identifier = String(describing: model.cellAnyType)
            if model.loadsFromNib {
                let bundle = Bundle(for: model.cellAnyType)
                let nib = UINib(nibName: identifier, bundle: bundle)
                register(nib, forHeaderFooterViewReuseIdentifier: identifier)
            } else {
                register(model.cellAnyType, forHeaderFooterViewReuseIdentifier: identifier)
            }
        }
    }
}
