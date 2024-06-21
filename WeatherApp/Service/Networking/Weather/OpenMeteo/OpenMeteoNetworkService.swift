import Foundation

final class OpenMeteoNetworkService: WeatherNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<WeatherModelAfterDTO, APIErrors>) -> Void) {
        APINetworkManager.request(to: OpenMeteoAPIEndpoint.getWeatherIn(longitude: longitude, latitude: latitude)) { (result: Result<OpenMeteoWeatherResponse, APIErrors>) -> Void in
            switch result {
            case .success(let openWeatherResponse):
                if let temperature = openWeatherResponse.current?.temperature2M, let weatherCondition = openWeatherResponse.current?.weatherCode?.description {
                    let weatherModel = WeatherModelAfterDTO(temperature: String(temperature), weatherCondition: weatherCondition)
                    completion(.success(weatherModel))
                } else {
                    completion(.failure(.noDataInResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
