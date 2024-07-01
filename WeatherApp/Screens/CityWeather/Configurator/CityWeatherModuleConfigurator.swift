import Foundation

final class CityWeatherModuleConfigurator {
    struct Dependecies {
        let weatherService: WeatherNetworkServiceProtocol
        let navigationController: ModuleTransitionableProtocol
        let cityName: String
        let longitude: Decimal
        let latitude: Decimal
    }

    static func configure(with dependencies: Dependecies ) -> CityWeatherViewController {
        let router = CityWeatherRouter(navigationController: dependencies.navigationController)
        let presenter = CityWeatherPresenter(router: router,
                                             weatherNetworkService: dependencies.weatherService,
                                             longitude: dependencies.longitude,
                                             latitude: dependencies.latitude,
                                             cityName: dependencies.cityName)
        let view = CityWeatherViewController(presenter: presenter)

        return view
    }
}
