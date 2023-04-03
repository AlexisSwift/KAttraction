import RxSwift

final class AttaractionListViewController: BaseViewController {
    typealias ViewModel = AttaractionListViewModel
    typealias Event = InputEvent
    
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
        title = L10n.attractions()
        view.background(Color.backgroundPrimary())
        
        viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                self.setupTableView()
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
        case .updateAttaractionList:
            endLoading()
            buildTable(source: viewModel.state.attraction)
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
    
    func buildTable(source: [AttaractionCell.AttractionConfig]) {
        var items: [CellViewModel] = []
        source.forEach { attaraction in
            items.append(SpacerCellViewModel(height: 16))
            let attractionCellViewModel = AttaractionCellViewModel(source: attaraction)
            attractionCellViewModel.onDetailAttractionsScreen = { [weak self] in
                self?.onDetailAttractionsScreen?($0)
            }
            items.append(attractionCellViewModel)
        }
        items.append(SpacerCellViewModel(height: 16))
        tableContainer.tableManager.set(items: items)
    }
}

// MARK: - Action, Event
extension AttaractionListViewController {
    enum Action {
        case load
    }
    
    enum InputEvent {
        case loading
        case updateAttaractionList
        case error(error: Error)
    }
}
