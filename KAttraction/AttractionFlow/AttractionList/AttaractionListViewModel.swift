final class AttaractionListViewModel: ViewModel {
    @DriverValue private(set) var state: State
    @DriverValue private(set) var event: Event = .loading
    
    private let attractionService: AttractionsServiceAbstract

    init(city: City, attractionService: AttractionsServiceAbstract) {
        state = State(city: city)
        self.attractionService = attractionService
        
        super.init()
    }

    func handle(_ action: Action) {
        switch action {
        case .load:
            loadAttractions()
        }
    }

    private func loadAttractions() {
        attractionService.getAttractions(in: state.city, completion: { [weak self] result in
            switch result {
            case let .success(response):
                self?.state.attractions = response.map(AttractionListItem.init)
                self?.event = response.isEmpty ? .empty : .content
            case let .failure(error):
                self?.event = .error(error: error)
            }
        })
    }
}

// MARK: - Controller's State
extension AttaractionListViewModel {
    final class State {
        fileprivate let city: City
        @DriverValue fileprivate(set) var attractions: [AttractionListItem] = []
        
        init (city: City) {
            self.city = city
        }
    }

    struct AttractionListItem {
        let images: [String]
        let name: String
        let description: String

        init(_ response: AttractionResponse) {
            images = response.images
            name = response.name
            description = response.description
        }
    }

    enum Action {
        case load
    }

    enum Event {
        case loading
        case content
        case empty
        case error(error: Error)
    }
}
