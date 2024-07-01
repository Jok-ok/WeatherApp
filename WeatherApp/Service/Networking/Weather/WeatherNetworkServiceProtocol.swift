import Foundation

protocol WeatherNetworkServiceProtocol {
    func getWeatherIn(
        longitude: Decimal,
        latitude: Decimal,
        completion: @escaping (Result<WeatherModelAfterDTO, APIErrors>) -> Void
    )

    func getWeatherForecast(
        longitude: Decimal,
        latitude: Decimal,
        completion: @escaping (Result<WeatherWithForecastAfterDTO, APIErrors>) -> Void
    )
}
