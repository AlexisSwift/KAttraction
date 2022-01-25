import RxSwift

public final class BaseTableContainerView: BaseView {
    public lazy var tableView = makeTableView()
    public lazy var tableManager: TableManagerAbstract = makeTableManager()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func setup() {
        assignTableManagerToTable()
        layoutTableView()
        register(cellModels: [SpacerCellViewModel.self])
    }

    public func register(cellModels: [CellViewModel.Type]) {
        tableView.register(cells: cellModels)
    }

    func assignTableManagerToTable() {
        tableManager.tableView = tableView
    }

    func makeTableView() -> UITableView {
        let tableView = BaseTableView()
        tableView.background(.clear)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }

    func makeTableManager() -> TableManagerAbstract {
        return BaseTableManager()
    }

    func layoutTableView() {
        guard !tableView.isDescendant(of: self) else {
            return
        }
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
