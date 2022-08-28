final class AttractionDetailsViewModel: ViewModel {
    
    typealias ControllerState = State
    typealias OutputEvent = AttaractionListViewController.InputEvent
    typealias InputAction = AttaractionListViewController.Action
    
    @DriverValue private(set) var state: ControllerState
    @DriverValue private(set) var event: OutputEvent = .loading
    
    private let attractionService: AttractionsServiceAbstract
    
    init(attractionName: String, city: City, attractionService: AttractionsServiceAbstract) {
        state = State(attractionName: attractionName, city: city)
        self.attractionService = attractionService
    }
    
    func handle(_ action: InputAction) {
        switch action {
        case .load:
            loadAttractions()
        }
    }
    
    private func loadAttractions() {
        attractionService.getAttractions(for: state.attractionName, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let filtredData = response.first(where: { $0.name == self.state.attractionName })
                    .map ({ attractionResponse in Attraction (images: attractionResponse.images,
                                                              name: attractionResponse.name,
                                                              description: attractionResponse.description,
                                                              descriptionFull: attractionResponse.descfull,
                                                              cityName: attractionResponse.geo.name,
                                                              longitude: attractionResponse.geo.lon,
                                                              latitude: attractionResponse.geo.lan)
                    })
                
                guard let filtredData = filtredData else {
                    return
                }
                
                self.state.detailAboutAttraction = filtredData
            case .failure(_):
                break
            }
        })
    }
}

// MARK: - Controller's State
extension AttractionDetailsViewModel {
    final class State {
        fileprivate(set) var attractionName: String
        
        @DriverValue fileprivate(set) var city: City
        @DriverValue fileprivate(set) var detailAboutAttraction: Attraction = Attraction(
            images: [""],
            name: "",
            description: "",
            descriptionFull: "",
            cityName: "",
            longitude: 0,
            latitude: 0
        )
        
        var pageIndex: Int = 0
        
        init (attractionName: String, city: City) {
            self.attractionName = attractionName
            self.city = city
        }
    }
}
