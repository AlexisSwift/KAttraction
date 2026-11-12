import RxSwift

final class AttaractionListViewController: BaseViewController {
    typealias ViewModel = AttaractionListViewModel
    typealias Event = AttaractionListViewModel.Event
    
    private var viewModel: ViewModel
    
    // MARK: - Handler
    var onDetailAttractionsScreen: StringHandler?
    
    // MARK: - UI Components
    private let tableContainer = BaseTableContainerView()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        
        viewModel.handle(.load)
    }
    
    private func setupView() {
        title = R.string.localizable.attractions()
        view.background(R.color.backgroundPrimary())
        setupTableView()
        
        viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                self.body(state: state).embedIn(self.view)
            }.disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.$event.drive { [weak self] event in
            self?.handle(event)
        }
        .disposed(by: disposeBag)
    }
    
    func handle(_ event: Event) {
        switch event {
        case .loading:
            startLoading()
        case .content:
            endLoading()
            buildTable(source: viewModel.state.attractions)
        case .empty:
            endLoading()
            buildTable(source: [])
            showAlert(message: NSLocalizedString("No attractions are available for this city.", comment: "Empty attraction list"))
        case let .error(message):
            showAlert(message: message.localizedDescription)
        }
    }
}
// MARK: - UI
extension AttaractionListViewController {
    private func body(state: ViewModel.State) -> UIView {
        VStack {
            tableContainer
        }.layoutMargins(hInset: 16)
    }
}

// MARK: - Table
private extension AttaractionListViewController {
    func setupTableView() {
        tableContainer.register(cellModels: [AttaractionCellViewModel.self])
    }
    
    func buildTable(source: [AttaractionListViewModel.AttractionListItem]) {
        var items: [CellViewModel] = []
        source.forEach { attraction in
            items.append(SpacerCellViewModel(height: 16))
            let config = AttaractionCell.AttractionConfig(
                attractionImage: attraction.images,
                attractionName: attraction.name,
                attractionDescription: attraction.description
            )
            let attractionCellViewModel = AttaractionCellViewModel(source: config, handler: onDetailAttractionsScreen)
            items.append(attractionCellViewModel)
        }
        items.append(SpacerCellViewModel(height: 16))
        tableContainer.tableManager.set(items: items)
    }
}
