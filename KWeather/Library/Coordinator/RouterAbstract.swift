import UIKit

/// Higher priority than TransitionConfig
public protocol NavigationBarAlwaysHidden {}
public protocol NavigationBarAlwaysVisible {}
public protocol NavigationBarWithoutItems {}

public struct TransitionConfig {
    public var animate: Bool = true
    public var showNavBar: Bool?
    public var showTabBar: Bool?
    public var completion: (() -> Void)?

    public func with(options: [TransitionOption]) -> TransitionConfig {
        var newConfig = self
        options.forEach { option in
            switch option {
            case .withoutAnimation:
                newConfig.animate = false
            case .withNavBar(let hidden):
                newConfig.showNavBar = !hidden
            case .withTabBar(let hidden):
                newConfig.showTabBar = !hidden
            case .withCompletion(let completion):
                newConfig.completion = completion
            }
        }
        return newConfig
    }
}

public enum TransitionOption {
    case withoutAnimation
    case withNavBar(hidden: Bool)
    case withTabBar(hidden: Bool)
    case withCompletion(_ completion: () -> Void)
}

public protocol RouterAbstract: Presentable {
    var rootController: UINavigationController? { get }

    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)

    func push(_ module: Presentable?, transitionOptions: [TransitionOption])

    func set(modules: [Presentable], animated: Bool)

    func popModule()
    func popToModule(_ module: Presentable?, animated: Bool)
    func popModule(animated: Bool)
    func popToModule<T: Presentable>(_: T.Type, animated: Bool, failHandler: (() -> Void)?)
    func popModule(animated: Bool, withCompletion completion: (() -> Void)?)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func dismissModule(_ module: Presentable?)
    func dismissModule(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func setRootModule(_ module: Presentable?, animated: Bool, hideBar: Bool)
    func setRootModule(_ module: Presentable?, transitionOptions: [TransitionOption])

    func replaceLast(_ module: Presentable?, animated: Bool, hideBar: Bool)
    func popToRootModule(animated: Bool)
    func popToRootModule(animated: Bool, withCompletion completion: (() -> Void)?)

    func addAsChild(_ module: Presentable?)
    func add(_ submodule: Presentable?, asChildTo module: Presentable?)

    func contains<T>(_: T.Type) -> Bool
    func child<T>(_: T.Type) -> T?
}

public extension RouterAbstract {
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func push(_ module: Presentable?) {
        push(module, transitionOptions: [])
    }

    func set(modules: [Presentable]) {
        set(modules: modules, animated: true)
    }

    func dismissModule(_ module: Presentable?) {
        dismissModule(module, animated: true, completion: nil)
    }

    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func popModule() {
        popModule(animated: true)
    }

    func popToModule(_ module: Presentable?) {
        popToModule(module, animated: true)
    }

    func popToModule<T: Presentable>(_: T.Type, animated: Bool) {
        popToModule(T.self, animated: animated, failHandler: nil)
    }
    func popToModule<T: Presentable>(_: T.Type, failHandler: (() -> Void)?) {
        popToModule(T.self, animated: true, failHandler: failHandler)
    }
    func popToModule<T: Presentable>(_: T.Type) {
        popToModule(T.self, animated: true, failHandler: nil)
    }

    func setRootModule(_ module: Presentable?) {
        setRootModule(module, transitionOptions: [])
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        setRootModule(module, animated: true, hideBar: hideBar)
    }

    func setRootModule(_ module: Presentable?, animated: Bool) {
        setRootModule(module, animated: animated, hideBar: false)
    }

    func popToRootModule(animated: Bool) {
        popToRootModule(animated: animated, withCompletion: nil)
    }
}
