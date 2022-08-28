import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var rootContainer: UINavigationController = UINavigationController()
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootContainer
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(router: Router(rootController: rootContainer))
        appCoordinator?.start()

        return true
    }
}

private extension AppDelegate {
    private func setupNavigationBar() {
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor(.gray)
        UINavigationBar.appearance().barTintColor = Palette.backgroundPrimary
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        UINavigationBar.appearance().isTranslucent = false
    }
}
