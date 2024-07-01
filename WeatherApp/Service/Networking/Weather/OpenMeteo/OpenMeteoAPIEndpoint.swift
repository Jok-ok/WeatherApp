import Foundation

enum OpenMeteoAPIEndpoint: APIEndpointProtocol {
    var urlString: String { "https://api.open-meteo.com/v1/forecast" }

    case getWeatherIn(longitude: Decimal, latitude: Decimal)
    case getWeatherWithForecast(longitude: Decimal, latitude: Decimal)

    var queryItems: [String: String] {
        var queryItemsDict = [String: String]()

        switch self {
        case .getWeatherIn(let longitude, let latitude):
            queryItemsDict["longitude"] = "\(longitude)"
            queryItemsDict["latitude"] = "\(latitude)"
            queryItemsDict["current"] = "temperature_2m,weather_code"
            queryItemsDict["timezone"] = "Europe/Moscow"

        case .getWeatherWithForecast(let longitude, let latitude):
            queryItemsDict["longitude"] = "\(longitude)"
            queryItemsDict["latitude"] = "\(latitude)"
            queryItemsDict["current"] = "temperature_2m,weather_code"
            queryItemsDict["hourly"] = "temperature_2m,precipitation_probability,weather_code"
            queryItemsDict["daily"] = "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset"
            queryItemsDict["timezone"] = "Europe/Moscow"
        }

        return queryItemsDict
    }

    var headers: [String: String] {
        [:]
    }

    var method: HTTPMethod { .get }
}
