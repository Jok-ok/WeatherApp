import UIKit

final class CitySearchModuleConfigurator {
    struct Dependecies {
        let navigationController: ModuleTransitionableProtocol
        let locationService: LocationServiceProtocol
        let geocodeService: GeocoderNetworkServiceProtocol
        let geoObjectPersistanceService: GeoObjectServiceProtocol
        let weatherService: WeatherNetworkServiceProtocol
    }
    
    static func configure(with dependencies: Dependecies) -> UIViewController {
        let router = CitySearchRouter(navigationController: dependencies.navigationController)
        let presenter = CitySearchPresenter(router: router, weatherService: dependencies.weatherService,
                                            locationService: dependencies.locationService,
                                            geocoderNetworkService: dependencies.geocodeService,
                                            geoObjectPersistenceService: dependencies.geoObjectPersistanceService)
        let view = CitySearchTableViewController(presenter: presenter)
        
        return view
    }
}
