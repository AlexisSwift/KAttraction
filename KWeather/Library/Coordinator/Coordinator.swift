import UIKit

/// Coordinator managing user history
public protocol Coordinator: AnyObject {
    func start()
    func start(withDeeplink deeplink: DeeplinkAbstract?)
    func open(url: String?)
    func open(url: URL)
}

public extension Coordinator {
    func open(url: String?) {
        guard
            let urlStr = url,
            let url = URL(string: urlStr) else {
            assertionFailure("Invalid url string")
            return
        }
        open(url: url)
    }

    func open(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

public protocol RoutableCoordinator: Coordinator {
    var router: RouterAbstract { get }
}
