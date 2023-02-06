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
        
        controller.showImageViewer = { [weak self] in
            self?.showImageViewer(images: viewModel.state.detailAboutAttraction.images, pageIndex: viewModel.state.pageIndex)
        }
        
        router.push(controller)
    }
}

// MARK: - ImageViewerControllerDelegate
extension MainFlowCoordinator: ImageViewerControllerDelegate {
    func showImageViewer(images: [String], pageIndex: Int) {
        let controller = ImageViewerController(imageURLs: images, pageIndex: pageIndex)
        controller.delegate = self
        router.present(controller)
    }
    
    func load(_ imageURL: String, into imageView: UIImageView, completion: (() -> Void)?) {
        imageView.setImage(withUrl: imageURL) { _ in
            completion?()
        }
    }
}
