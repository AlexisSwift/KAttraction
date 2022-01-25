import UIKit

final class SearchViewController: UIViewController {
    
    private(set) var state = State()
    
    var onAttractionScreen: CityHandler?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Palette.backgroundPrimary
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        state.filteredCity = state.city
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.layer.cornerRadius = 12
        
        searchBar.placeholder = Localization.SearchFlow.Search.find
        searchBar.tintColor = .white
        searchBar.searchField?.textColor = .white
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.backgroundColor = Palette.backgroundPrimary
        tableView.separatorStyle = .none
    }
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.filteredCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 32, weight: .heavy)
        cell.backgroundColor = Palette.backgroundPrimary
        cell.textLabel?.textColor = .white
        
        guard indexPath.row < state.filteredCity.count else {
            return cell
        }
        
        cell.textLabel?.text = state.filteredCity[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < state.filteredCity.count  else {
            return
        }
        
        let city = state.filteredCity[indexPath.row]
        self.onAttractionScreen?(city)

    }
}

// MARK: - Controller's State
extension SearchViewController {
    final class State {
        var city = [
            City(name: "Калининград", latitude: 54.7065, longitude: 20.511),
            City(name: "Санкт-Петербург", latitude: 59.9386, longitude: 30.3141),
            City(name: "Вильнюс", latitude: 54.6892, longitude: 25.2798),
            City(name: "Минск", latitude: 53.9, longitude: 27.5667),
            City(name: "Берлин", latitude: 52.5244, longitude: 13.4105)
        ]
        var filteredCity: [City] = []
    }
}

// MARK: - SearchView
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" else {
            state.filteredCity = state.city
            self.tableView.reloadData()
            return
        }
        
        state.filteredCity = []
        
        for city in state.city {
            if city.name.uppercased().contains(searchText.uppercased()) {
                state.filteredCity.append(city)
            }
        }
        self.tableView.reloadData()
    }
}
