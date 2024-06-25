import Foundation
import UIKit.UIAlertController

final class CitySearchRouter: CitySearchRouterProtocol {
    private let navigationController: ModuleTransitionableProtocol
    
    init(navigationController: ModuleTransitionableProtocol) {
        self.navigationController = navigationController
    }
    
    func showWeatherFor(city: String, latitude: Decimal, longitude: Decimal, weatherNetworkService: WeatherNetworkServiceProtocol) {
        let dependencies =  CityWeatherModuleConfigurator.Dependecies(weatherService: weatherNetworkService, navigationController: navigationController, cityName: city, longitude: longitude, latitude: latitude)
        let cityWeatherViewController = CityWeatherModuleConfigurator.configure(with: dependencies)
        navigationController.push(module: cityWeatherViewController, animated: true)
    }
    
    func showError(with title: String, message: String, cancelButtonTitle: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(.init(title: cancelButtonTitle, style: .cancel))
        navigationController.present(module: errorAlert, animated: true)
    }
}
