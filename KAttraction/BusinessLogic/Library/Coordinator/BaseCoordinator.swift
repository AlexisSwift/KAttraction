import UIKit
// Abstract coordinator class

// swiftlint:disable final_class
open class BaseCoordinator: Coordinator {
    public typealias DefaultFinishHandler = () -> Void

    public var upcomingDeeplink: DeeplinkAbstract?
    public var childCoordinators: [Coordinator] = []

    open func start() {
        start(withDeeplink: nil)
    }

    open func start(withDeeplink deeplink: DeeplinkAbstract?) {
    }

    public func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    public func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isNotEmpty,
            let coordinator = coordinator
        else { return }

        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: childCoordinators.count - index - 1)
            break
        }
    }

    public func removeDependency<T: Coordinator>(of coordinatorType: T.Type) {
        guard
            childCoordinators.isNotEmpty
        else { return }

        for (index, element) in childCoordinators.reversed().enumerated() where type(of: element) == coordinatorType {
            childCoordinators.remove(at: childCoordinators.count - index - 1)
            break
        }
    }

    public func removeAllDependencies() {
        childCoordinators.removeAll()
    }

    public func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }

    public init() { }

    #if DEV || INT
    deinit {
        print(#function, type(of: self))
    }
    #endif
}

public extension BaseCoordinator {
    func contains<C: Coordinator>(child _: C.Type) -> Bool {
        return childCoordinators.contains(where: { type(of: $0) == C.self })
    }

    func child<C: Coordinator>(ofType _: C.Type) -> C? {
        return childCoordinators.first(where: { type(of: $0) == C.self }) as? C
    }
}
