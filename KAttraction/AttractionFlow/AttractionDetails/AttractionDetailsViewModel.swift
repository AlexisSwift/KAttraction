final class AttractionDetailsViewModel: ViewModel {
    @DriverValue private(set) var state: State
    @DriverValue private(set) var event: Event = .idle
    
    private let attractionService: AttractionsServiceAbstract
    
    init(attractionName: String, city: City, attractionService: AttractionsServiceAbstract) {
        state = State(attractionName: attractionName, city: city)
        self.attractionService = attractionService
    }
    
    func handle(_ action: Action) {
        switch action {
        case .load:
            loadAttractions()
        case let .scrollImage(index):
            state.pageIndex = index
        }
    }
    
    private func loadAttractions() {
        event = .loading
        attractionService.getAttraction(named: state.attractionName, in: state.city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(attraction):
                self.state.detailAboutAttraction = attraction
                self.event = .content
            case let .failure(error):
                self.event = .error(error: error)
            }
        }
    }
}

// MARK: - Controller's State
extension AttractionDetailsViewModel {
    final class State {
        let attractionName: String
        
        @DriverValue fileprivate(set) var city: City
        @DriverValue fileprivate(set) var detailAboutAttraction: Attraction?
        
        fileprivate(set) var pageIndex: Int = .zero
        
        init(attractionName: String, city: City) {
            self.attractionName = attractionName
            self.city = city
        }
    }

    enum Action {
        case load
        case scrollImage(Int)
    }

    enum Event {
        case idle
        case loading
        case content
        case error(error: Error)
    }
}
