import UIKit

final class AppCoordinator: BaseCoordinator {
    private(set) var router: RouterAbstract
    
    init(
        router: RouterAbstract
    ) {
        self.router = router
    }
    
    override func start() {
        showMainScreen()
    }
}

private extension AppCoordinator {
    func showMainScreen() {
        let coordinator = MainFlowCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}
