import UIKit

final class AppCoordinator: BaseCoordinator {
    private(set) var router: RouterAbstract
    
    init(
        router: RouterAbstract
    ) {
        self.router = router
    }
    
    override func start() {
        showSearchScreen()
    }
}

private extension AppCoordinator {
    func showSearchScreen() {
        let controller = SearchViewController()
        
        controller.onAttractionScreen = { [weak self] city in
            self?.showAttractionsScreen(city: city)
        }
        
        router.setRootModule(controller)
    }
    
    func showCityWeatherScreen(city: City) {
        let controller = CityWeatherViewContoller(viewModel: CityWeatherViewModel(city: city, weatherService: WeatherService()))
        
        router.push(controller)
    }
    
    func showAttractionsScreen(city: City) {
        let controller = AttaractionListViewController(viewModel: AttaractionListViewModel(city: city, attractionService: AttractionsService()))
        
        controller.onDetailAttractionsScreen = { [weak self] in
            self?.showDetaillAboutAttractionScreen(attractionName: $0, city: city)
        }
        
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
