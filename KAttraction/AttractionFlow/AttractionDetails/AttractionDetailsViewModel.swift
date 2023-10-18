final class AttractionDetailsViewModel: ViewModel {
    
    typealias ControllerState = State
    typealias OutputEvent = AttractionDetailsViewController.InputEvent
    typealias InputAction = AttractionDetailsViewController.Action
    
    @DriverValue private(set) var state: ControllerState
    @DriverValue private(set) var event: OutputEvent = .none
    
    private let attractionService: AttractionsServiceAbstract
    
    init(attractionName: String, city: City, attractionService: AttractionsServiceAbstract) {
        state = State(attractionName: attractionName, city: city)
        self.attractionService = attractionService
    }
    
    func handle(_ action: InputAction) {
        switch action {
        case .load:
            loadAttractions()
        case let .scrollImage(index):
            state.pageIndex = index
        }
    }
    
    private func loadAttractions() {
        attractionService.getAttractions(for: state.attractionName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                let filtredData = response
                    .first(where: { $0.name == self.state.attractionName })
                    .map { attractionResponse in Attraction(images: attractionResponse.images,
                                                            name: attractionResponse.name,
                                                            description: attractionResponse.description,
                                                            descriptionFull: attractionResponse.descfull,
                                                            cityName: attractionResponse.geo.name,
                                                            longitude: attractionResponse.geo.lon,
                                                            latitude: attractionResponse.geo.lan)
                    }
                
                guard let filtredData = filtredData else { return }
                self.state.detailAboutAttraction = filtredData
            case let .failure(error):
                self.event = .error(error: error)
            }
        }
    }
}

// MARK: - Controller's State
extension AttractionDetailsViewModel {
    final class State {
        fileprivate(set) var attractionName: String
        
        @DriverValue fileprivate(set) var city: City
        @DriverValue fileprivate(set) var detailAboutAttraction: Attraction = Attraction(
            images: [String()],
            name: String(),
            description: String(),
            descriptionFull: String(),
            cityName: String(),
            longitude: .zero,
            latitude: .zero
        )
        
        fileprivate(set) var pageIndex: Int = .zero
        
        init(attractionName: String, city: City) {
            self.attractionName = attractionName
            self.city = city
        }
    }
}
