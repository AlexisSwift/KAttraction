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
        let controller = SearchViewController(viewModel: SearchViewModel())
        
        controller.onAttractionScreen = { [weak self] city in
            self?.showAttractionsScreen(city: city)
        }
        
        router.setRootModule(controller)
    }
}

// MARK: - Main
private extension MainFlowCoordinator {
    private func showAttractionsScreen(city: City) {
        let controller = AttaractionListViewController(viewModel: AttaractionListViewModel(city: city, attractionService: AttractionsService()))
        
        controller.onDetailAttractionsScreen = { [weak self] in
            self?.showDetaillAboutAttractionScreen(attractionName: $0, city: city)
        }
        
        router.push(controller, transitionOptions: [TransitionOption.withNavBar(hidden: false)])
    }
    
    private func showCityWeatherScreen(city: City) {
        let controller = CityWeatherViewContoller(viewModel: CityWeatherViewModel(city: city, weatherService: WeatherService()))
        
        router.push(controller)
    }
    
    private func showDetaillAboutAttractionScreen(attractionName: String, city: City) {
        let viewModel = AttractionDetailsViewModel(attractionName: attractionName, city: city, attractionService: AttractionsService())
        let controller = AttractionDetailsViewController(viewModel: viewModel)
        
        controller.onWeatherScreen = { [weak self] in
            self?.showCityWeatherScreen(city: $0)
        }
        
        controller.showImageViewer = { [weak self, weak controller] in
            self?.showImageViewer(
                images: viewModel.state.detailAboutAttraction.images,
                pageIndex: viewModel.state.pageIndex,
                delegate: controller
            )
        }
        
        router.push(controller)
    }
}

extension MainFlowCoordinator {
    func showImageViewer(images: [String], pageIndex: Int, delegate: ImageViewerControllerDelegate?) {
        let controller = ImageViewerController(imageURLs: images, pageIndex: pageIndex, delegate: delegate)
        router.present(controller)
    }
}
