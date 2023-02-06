import Foundation

final class SearchViewModel: ViewModel {
    
    typealias ControllerState = State
    typealias OutputEvent = SearchViewController.InputEvent
    typealias InputAction = SearchViewController.Action
    
    @DriverValue private(set) var state: ControllerState
    @DriverValue private(set) var event: OutputEvent = .none
    
    override init() {
        state = State()
        super.init()
    }
    
    func handle (_ action: InputAction) {
        switch action {
        case let .search(text):
            search(searchText: text)
        case .getCity:
            state.filteredCity = state.city
            event = .updateTable(source: state.filteredCity)
        }
    }
}

private extension SearchViewModel {
    @objc
    private func loadCitys() {
        guard state.query != "" else {
            state.filteredCity = state.city
            event = .updateTable(source: state.filteredCity)
            return
        }
        
        state.filteredCity = []
        
        for city in state.city {
            if city.name.uppercased().contains(state.query.uppercased()) {
                state.filteredCity.append(city)
            }
        }
        
        event = .updateTable(source: state.filteredCity)
    }
    
    private func search(searchText: String?) {
        state.query = searchText ?? ""
        state.timerSearch?.invalidate()
        
        state.timerSearch = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(loadCitys),
            userInfo: nil,
            repeats: false
        )
    }
}

// MARK: - Controller's State
extension SearchViewModel {
    final class State {
        fileprivate(set) var city = [
            City(name: "Калининград", latitude: 54.7065, longitude: 20.511),
            City(name: "Санкт-Петербург", latitude: 59.9386, longitude: 30.3141),
            City(name: "Вильнюс", latitude: 54.6892, longitude: 25.2798),
            City(name: "Минск", latitude: 53.9, longitude: 27.5667),
            City(name: "Берлин", latitude: 52.5244, longitude: 13.4105)
        ]
        fileprivate(set) var filteredCity: [City] = []
        
        fileprivate(set) var timerSearch: Timer?
        fileprivate(set) var query = String()
    }
}
