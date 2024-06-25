import Foundation

protocol CitySearchRouterProtocol {
    func showWeatherFor(city: String, latitude: Decimal, longitude: Decimal, weatherNetworkService: WeatherNetworkServiceProtocol)
    func showError(with title: String, message: String, cancelButtonTitle: String) 
}
