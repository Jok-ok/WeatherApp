import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        initializeRootView(with: scene)
    }
}
private extension SceneDelegate {
    func initializeRootView(with scene: UIWindowScene) {
        window = UIWindow(windowScene: scene )
        let navigationController = UINavigationController()
        let locationService = LocationService()
        let geoCoderService = GeocoderNetworkService()
        let weatherService = OpenMeteoNetworkService()
        let geoObjectPersistanceService = GeoObjectPersistentService(coreDataStack: CoreDataStack.shared)
        let dependencies = CitySearchModuleConfigurator.Dependecies(
            navigationController: navigationController,
            locationService: locationService,
            geocodeService: geoCoderService,
            geoObjectPersistanceService: geoObjectPersistanceService,
            weatherService: weatherService)
        let viewController = CitySearchModuleConfigurator.configure(with: dependencies)

        navigationController.viewControllers = [viewController]
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
