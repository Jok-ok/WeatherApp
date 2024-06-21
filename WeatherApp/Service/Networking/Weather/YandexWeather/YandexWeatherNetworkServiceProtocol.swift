import Foundation

protocol YandexWeatherNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<YandexAPIWeatherResponse, APIErrors>) -> Void)
}
