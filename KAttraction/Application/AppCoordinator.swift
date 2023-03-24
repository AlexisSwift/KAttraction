import UIKit
import Network

final class AppCoordinator: BaseCoordinator {
    private(set) var router: RouterAbstract
    
    private let monitor = NWPathMonitor()
    
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
        monitor.start(queue: DispatchQueue(label: "queueForMonitor"))
        monitor.pathUpdateHandler = { [weak self, monitor] path in
            if path.status == .unsatisfied {
                
                DispatchQueue.main.async {
                    guard self?.router.rootController?.visibleViewController as? DisableNetworkViewController == nil else { return }
                    let controller = DisableNetworkViewController(monitor: monitor)
                    controller.modalPresentationStyle = .overFullScreen
                    DispatchQueue.main.async {
                        self?.router.present(controller)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.router.dismissModule()
                }
            }
        }
    }
}
