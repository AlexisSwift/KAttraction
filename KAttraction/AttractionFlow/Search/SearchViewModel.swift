final class SearchViewModel: ViewModel {
    @DriverValue private(set) var state: State
    @DriverValue private(set) var event: Event = .idle
    
    override init() {
        state = State()
        super.init()
    }
    
    func handle (_ action: Action) {
        switch action {
        case let .search(text):
            search(searchText: text)
        case .load:
            state.filteredCity = state.city
            event = .updateTable(source: state.filteredCity)
        }
    }
}

private extension SearchViewModel {
    private func search(searchText: String?) {
        let query = (searchText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            state.filteredCity = state.city
            event = .updateTable(source: state.filteredCity)
            return
        }

        state.filteredCity = state.city.filter {
            $0.name.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
        event = .updateTable(source: state.filteredCity)
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
        
    }

    enum Action {
        case search(text: String?)
        case load
    }

    enum Event {
        case idle
        case updateTable(source: [City])
    }
}
