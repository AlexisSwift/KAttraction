final class AttaractionListViewModel: ViewModel {

    typealias ControllerState = State
    typealias OutputEvent = AttaractionListViewController.InputEvent
    typealias InputAction = AttaractionListViewController.Action

    @DriverValue private(set) var state: ControllerState
    @DriverValue private(set) var event: OutputEvent = .loading
    
    private let attractionService: AttractionsServiceAbstract

    init(city: City, attractionService: AttractionsServiceAbstract) {
        state = State(city: city)
        self.attractionService = attractionService
        
        super.init()
    }

    func handle(_ action: InputAction) {
        switch action {
        case .load:
            loadAttractions()
        }
    }

    private func loadAttractions() {
        attractionService.getAttractions(for: state.cityName, completion: { [weak self] result in
            switch result {
            case let .success(response):
                self?.state.attraction = response
                    .filter { $0.geo.name == self?.state.cityName }
                    .map({ attractionResponse in
                        AttaractionCell.AttractionConfig(
                            attractionImage: attractionResponse.images,
                            attractionName: attractionResponse.name,
                            attractionDescription: attractionResponse.description)
                    })
                self?.event = .updateAttaractionList
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
        fileprivate let cityName: String
        
        @DriverValue fileprivate(set) var attraction: [AttaractionCell.AttractionConfig] = []
        
        init (city: City) {
            self.city = city
            self.cityName = city.name
        }
    }
}
