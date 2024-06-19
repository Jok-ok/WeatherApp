import UIKit

final class CitySearchModuleConfigurator {
    struct Dependecies {
        let navigationController: ModuleTransitionableProtocol
        let suggestService: SuggestNetworkServiceProtocol
        let locationService: LocationServiceProtocol
    }
    
    static func configure(with dependencies: Dependecies) -> UIViewController {
        let router = CitySearchRouter(navigationController: dependencies.navigationController)
        let presenter = CitySearchPresenter(router: router,
                                            suggestService: dependencies.suggestService,
                                            locationService: dependencies.locationService)
        let view = CitySearchTableViewController(presenter: presenter)
        
        return view
    }
}
