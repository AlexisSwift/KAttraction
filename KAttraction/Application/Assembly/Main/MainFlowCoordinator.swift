import UIKit

final class MainFlowCoordinator: BaseCoordinator {
    var finishFlow: DefaultFinishHandler?
    
    var onHomeFlow: VoidHandler?
    var onChoiceFlow: VoidHandler?
    
    let router: RouterAbstract
    
    init(router: RouterAbstract) {
        self.router = router
    }
    
    // MARK: - Start
    
    override func start() {
        
        // MARK: - Search
        let controller = SearchViewController()
        
        controller.onAttractionScreen = { [weak self] city in
            self?.showAttractionsScreen(city: city)
        }
        
        router.setRootModule(controller)
    }
}

// MARK: - Main
extension MainFlowCoordinator {
    func showAttractionsScreen(city: City) {
        let controller = AttaractionListViewController(viewModel: AttaractionListViewModel(city: city, attractionService: AttractionsService()))
        
        controller.onDetailAttractionsScreen = { [weak self] in
            self?.showDetaillAboutAttractionScreen(attractionName: $0, city: city)
        }
        
        router.push(controller, transitionOptions: [TransitionOption.withNavBar(hidden: false)])
    }
    
    func showCityWeatherScreen(city: City) {
        let controller = CityWeatherViewContoller(viewModel: CityWeatherViewModel(city: city, weatherService: WeatherService()))
        
        router.push(controller)
    }
    
    func showDetaillAboutAttractionScreen(attractionName: String, city: City) {
        let controller = AttractionDetailsViewController(viewModel: AttractionDetailsViewModel(attractionName: attractionName, city: city, attractionService: AttractionsService()))
        
        controller.onWeatherScreen = { [weak self] in
            self?.showCityWeatherScreen(city: $0)
        }
        
        router.push(controller)
    }
}
