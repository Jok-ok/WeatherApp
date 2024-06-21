import Foundation

final class YandexWeatherNetworkService: WeatherNetworkServiceProtocol {
    func getWeatherIn(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<WeatherModelAfterDTO, APIErrors>) -> Void) {
        APINetworkManager.request(to: YandexWeatherAPIEndpoint.getWeatherIn(longitude: longitude, latitude: latitude)) {(result: Result<YandexAPIWeatherResponse, APIErrors>) -> Void in
            switch result {
            case .success(let weatherResponse):
                if let temperature = weatherResponse.fact?.temp,
                   let condition = weatherResponse.fact?.condition?.description {
                    let weatherModel = WeatherModelAfterDTO(temperature: String(temperature), weatherCondition: condition)
                    completion(.success(weatherModel))
                }
                completion(.failure(.noDataInResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
