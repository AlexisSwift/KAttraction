import UIKit

// swiftlint:disable final_class
open class Router: NSObject, RouterAbstract {
    public weak var rootController: UINavigationController?
    private var completions: [UIViewController: () -> Void]

    public init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }

    public func toPresent() -> UIViewController? {
        return rootController
    }

    public func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }

        var topController: UIViewController? = rootController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        topController?.present(controller, animated: animated, completion: nil)
    }

    public func set(modules: [Presentable], animated: Bool) {
        let controllers = modules.compactMap { $0.toPresent() }
        rootController?.setViewControllers(controllers, animated: animated)
    }

    public func dismissModule(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        module?.toPresent()?.dismiss(animated: animated, completion: completion)
    }

    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }

    public func push(_ module: Presentable?, transitionOptions: [TransitionOption]) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
        else { assertionFailure("Deprecated push UINavigationController."); return }

        let config = TransitionConfig().with(options: transitionOptions)

        if let completion = config.completion {
            completions[controller] = completion
        }

        rootController?.pushViewController(controller, animated: config.animate)

        config.showNavBar.flatMap {
            rootController?.setNavigationBarHidden(!$0, animated: config.animate)
        }
        config.showTabBar.flatMap {
            rootController?.setToolbarHidden(!$0, animated: config.animate)
        }
    }

    public func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    public func popModule(animated: Bool, withCompletion completion: (() -> Void)?) {
        rootController?.popViewController(animated: animated, completion: completion)
    }

    @available(*, deprecated)
    public func setRootModule(_ module: Presentable?, animated: Bool, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: animated)
        rootController?.isNavigationBarHidden = hideBar
        dismissModule()
    }

    public func setRootModule(_ module: Presentable?, transitionOptions: [TransitionOption]) {
        guard let controller = module?.toPresent() else { return }
        let config: TransitionConfig = TransitionConfig().with(options: transitionOptions)

        rootController?.setViewControllers([controller], animated: config.animate)

        config.showNavBar.flatMap {
            rootController?.setNavigationBarHidden(!$0, animated: config.animate)
        }

        dismissModule()
    }

    public func replaceLast(_ module: Presentable?, animated: Bool, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        var newControllers = rootController?.viewControllers.dropLast() ?? []
        newControllers.append(controller)

        rootController?.setViewControllers(newControllers, animated: animated)
        rootController?.isNavigationBarHidden = hideBar
    }

    public func popToModule(_ module: Presentable?, animated: Bool) {
        guard let view = module?.toPresent() else { return }
        rootController?.popToViewController(view, animated: animated)?.forEach { controller in
            runCompletion(for: controller)
        }
    }

    public func popToModule<T: Presentable>(_: T.Type, animated: Bool, failHandler: (() -> Void)?) {
        guard let module = child(T.self) else {
            failHandler?()
            return
        }
        popToModule(module, animated: animated)
    }

    public func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }

    public func popToRootModule(animated: Bool, withCompletion completion: (() -> Void)?) {
        rootController?.popToRootController(animated: animated, completion: completion)
    }

    public func addAsChild(_ module: Presentable?) {
        guard
            let rootController = rootController,
            let controller = module?.toPresent() else {
            return
        }
        controller.view.frame = controller.view.bounds
        rootController.addChild(controller)
        rootController.view.addSubview(controller.view)
    }

    public func add(_ submodule: Presentable?, asChildTo module: Presentable?) {
        guard let subcontroller = submodule?.toPresent(),
                let controller = module?.toPresent() else { return }

        subcontroller.view.frame = subcontroller.view.bounds
        controller.addChild(subcontroller)
        controller.view.addSubview(subcontroller.view)
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }

    public func removeFromParentIfNeeded() {
        rootController?.view.fadeOut { [weak self] in
            self?.rootController?.removeFromParent()
            self?.rootController?.view.removeFromSuperview()
        }
    }

    public func contains<T>(_: T.Type) -> Bool {
        return rootController?.viewControllers.contains(T.self) ?? false
    }

    public func child<T>(_: T.Type) -> T? {
        return rootController?.viewControllers.first(T.self)
    }

    #if DEV
    deinit {
        print(#function, type(of: self))
    }
    #endif
}
