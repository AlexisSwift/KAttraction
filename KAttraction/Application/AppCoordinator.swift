import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private(set) var router: RouterAbstract
    
    init(router: RouterAbstract) {
        self.router = router
    }
    
    override func start() {
        showMainScreen()
        
        configNetworkMonitor()
    }
}

private extension AppCoordinator {
    private func showMainScreen() {
        let coordinator = MainFlowCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}

// MARK: - Network
private extension AppCoordinator {
    private func configNetworkMonitor() {
        NetworkStatusService.shared.startMonitor()
        
        NetworkStatusService.shared.satisfied = { [weak self] in
            DispatchQueue.main.async {
                self?.router.dismissModule()
            }
        }
        
        NetworkStatusService.shared.unsatisfied = { [weak self] in
            guard self?.router.rootController?.visibleViewController as? DisableNetworkViewController == nil else { return }
            let controller = DisableNetworkViewController(monitor: NetworkStatusService.shared.monitor)
            controller.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self?.router.present(controller)
            }
        }
    }
}
