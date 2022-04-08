import UIKit.UITableView

// swiftlint:disable:next final_class
open class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    convenience init(configurator: (BaseTableView) -> Void) {
        self.init(frame: .zero, style: .plain)
        configurator(self)
    }

    func setup() {
        tableFooterView = UIView()
        separatorStyle = .none

        // commonly used cells
        registerTemplateCell(forView: Spacer.self)
        registerTemplateCell(forView: Separator.self)
    }
}

extension UITableView {

    func register<T: UITableViewCell>(cellClass: T.Type) {
        let cellReuseIdentifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
    }

    func registerTemplateCell<V: UIView>(forView _: V.Type) {
        register(cellClass: TemplateTableViewCell<V>.self)
    }
}

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(forCellClass cellClass: T.Type,
                                                 for indexPath: IndexPath,
                                                 configure: ((T) -> Void)? = nil) -> UITableViewCell {
        let cellReuseIdentifier = String(describing: cellClass)
        let cell = dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! T
        configure?(cell)
        return cell
    }

    func dequeueReusableTemplateCell<V: UIView>(forView _: V.Type,
                                                for indexPath: IndexPath,
                                                configure: (((view: V, cell: TemplateTableViewCell<V>)) -> Void)? = nil) -> TemplateTableViewCell<V> {
        let cell = dequeueReusableCell(forCellClass: TemplateTableViewCell<V>.self, for: indexPath) as! TemplateTableViewCell<V>
        configure?((view: cell.rootView, cell: cell))
        return cell
    }
}
