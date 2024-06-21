import Foundation

protocol WeatherNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<WeatherModelAfterDTO, APIErrors>) -> Void)
}
