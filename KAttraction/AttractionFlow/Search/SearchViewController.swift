import RxSwift

final class SearchViewController: BaseViewController {
    typealias ViewModel = SearchViewModel
    typealias Event = InputEvent
    
    private var viewModel: ViewModel
    
    // MARK: - Handlers
    var onAttractionScreen: CityHandler?
    
    // MARK: - UI Components
    private let refreshControl = UIRefreshControl(color: .darkGray)
    private let tableContainer = BaseTableContainerView()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.layer.cornerRadius = 12
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    // MARK: - Initializers
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.handle(.getCity)
    }
    
    private func setupView() {
        title = L10n.chooseYourCity()
        view.backgroundColor = Color.backgroundPrimary()
        setupSearchBar()
        setupTableView()
        
        viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                
                self.body(state: state).embedInWithSafeArea(self.view)
                
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
        case .none:
            break
        case let .updateTable(source):
            buildTable(source: source)
        }
    }
}

// MARK: - UI
private extension SearchViewController {
    private func body(state: ViewModel.State) -> UIView {
        VStack {
            tableContainer
        }
    }
    
    private func setupSearchBar() {
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .automatic
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - Table
private extension SearchViewController {
    private func setupTableView() {
        tableContainer.register(cellModels: [CityCellViewModel.self])
        tableContainer.tableView.separatorStyle = .singleLine
        tableContainer.tableView.separatorColor = .gray
        tableContainer.tableView.separatorInset = .zero
        
        tableContainer.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func buildTable(source: [City]) {
        tableContainer.tableManager.set(items: source.map { CityCellViewModel(source: $0, handler: onAttractionScreen) })
    }
}

// MARK: - SearchView
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.handle(.search(text: searchController.searchBar.text))
    }
}

// MARK: - Actions
@objc
private extension SearchViewController {
    private func refresh(_ sender: AnyObject) {
        viewModel.handle(.getCity)
        sender.endRefreshing()
    }
}

// MARK: - Action, Event
extension SearchViewController {
    enum Action {
        case search(text: String?)
        case getCity
    }
    
    enum InputEvent {
        case none
        case updateTable(source: [City])
    }
}
