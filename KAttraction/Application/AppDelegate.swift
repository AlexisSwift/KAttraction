import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {
    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()
        return true
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let rootContainer = UINavigationController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootContainer
        self.window = window

        appCoordinator = AppCoordinator(router: Router(rootController: rootContainer))
        appCoordinator?.start()
        window.makeKeyAndVisible()
    }
}

private extension AppDelegate {
    private func setupNavigationBar() {
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor(.gray)
        UINavigationBar.appearance().barTintColor = R.color.backgroundPrimary()
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        UINavigationBar.appearance().isTranslucent = false
    }
}
