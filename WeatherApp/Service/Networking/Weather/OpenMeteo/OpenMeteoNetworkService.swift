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
    
    func getWeatherForecast(longitude: Decimal, latitude: Decimal, completion: @escaping (Result<WeatherWithForecastAfterDTO, APIErrors>) -> Void) {
        APINetworkManager.request(to: OpenMeteoAPIEndpoint.getWeatherWithForecast(longitude: longitude, latitude: latitude)) { (result: Result<OpenMeteoWeatherResponse, APIErrors>) -> Void in
            let dateTimeFormatter = DateFormatter()

            dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            switch result {
            case .success(let weatherResponse):
                guard let hourlyTemperature = weatherResponse.hourly?.temperature2M,
                      let precipitationProbability = weatherResponse.hourly?.precipitationProbability,
                      let hourlyWeatherConditions = weatherResponse.hourly?.weatherCode,
                      let hourlyTimes = weatherResponse.hourly?.time else { completion(.failure(.noDataInResponse)); return }
                
                let hourlyForecast = WeatherWithForecastAfterDTO.HourlyForecast(
                    temperature: hourlyTemperature,
                    precipitationProbability: precipitationProbability,
                    weatherConditions: hourlyWeatherConditions.compactMap({ $0.description }),
                    times: hourlyTimes.compactMap({ dateTimeFormatter.date(from: $0) }))
                
                guard let dailyMinTemperatures = weatherResponse.daily?.temperature2MMin,
                      let dailyMaxTemperatures = weatherResponse.daily?.temperature2MMax,
                      let dailyWeatherConditions = weatherResponse.daily?.weatherCode,
                      let dailySunrise = weatherResponse.daily?.sunrise,
                      let dailySunset = weatherResponse.daily?.sunset,
                      let dailyTimes = weatherResponse.daily?.time else { completion(.failure(.noDataInResponse)); return }
                
                let dailyForecast = WeatherWithForecastAfterDTO.DailyForecast(
                    maxTemperatures: dailyMaxTemperatures,
                    minTemperatures: dailyMinTemperatures,
                    weatherConditions: dailyWeatherConditions.compactMap({ $0.description }),
                    sunrinse: dailySunrise.compactMap({ dateTimeFormatter.date(from: $0) }),
                    sunset: dailySunset.compactMap({ dateTimeFormatter.date(from: $0) }),
                    times: dailyTimes.compactMap({ dateFormatter.date(from: $0) }))
                
                guard let currentTemperature = weatherResponse.current?.temperature2M,
                      let currentWeatherCode = weatherResponse.current?.weatherCode else { completion(.failure(.noDataInResponse)); return }
                
                let model = WeatherWithForecastAfterDTO(temperature: currentTemperature, weatherCondition: currentWeatherCode.description, dailyForecast: dailyForecast, hourlyForecast: hourlyForecast)
                
                completion(.success(model))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
