import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        initializeRootView(with: scene)
    }
}
private extension SceneDelegate {
    func initializeRootView(with scene: UIWindowScene){
        window = UIWindow(windowScene: scene )
        let navigationController = UINavigationController()
        let suggestNetworkService = SuggestNetworkService()
        let locationService = LocationService()
        let geoCoderService = GeocoderNetworkService()
        let geoObjectPersistanceService = GeoObjectPersistentService(coreDataStack: CoreDataStack.shared)
        let dependencies = CitySearchModuleConfigurator.Dependecies(navigationController: navigationController,
                                                                    suggestService: suggestNetworkService,
                                                                    locationService: locationService,
                                                                    geocodeService: geoCoderService,
                                                                    geoObjectPersistanceService: geoObjectPersistanceService)
        let viewController = CitySearchModuleConfigurator.configure(with: dependencies)
        
        navigationController.viewControllers = [viewController]
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
