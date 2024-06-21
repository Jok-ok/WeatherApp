import Foundation

final class YandexWeatherNetworkService: YandexWeatherNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<YandexAPIWeatherResponse, APIErrors>) -> Void) {
        APINetworkManager.request(to: YandexWeatherAPIEndpoint.getWeatherIn(longitude: longitude, latitude: latitude), with: completion)
    }
}
