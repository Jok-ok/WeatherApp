import Foundation

protocol OpenMeteoNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<OpenMeteoWeatherResponse, APIErrors>) -> Void)
}
