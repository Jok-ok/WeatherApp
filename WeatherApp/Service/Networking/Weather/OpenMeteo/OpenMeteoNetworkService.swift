import Foundation

final class OpenMeteoNetworkService: OpenMeteoNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<OpenMeteoWeatherResponse, APIErrors>) -> Void) {
        APINetworkManager.request(to: OpenMeteoAPIEndpoint.getWeatherIn(longitude: longitude, latitude: latitude), with: completion)
    }
}
