import Foundation

enum YandexWeatherAPIEndpoint: APIEndpointProtocol {
    private var apiKey: String { ApiKeys.weatherApiKey }
    var urlString: String { "https://api.weather.yandex.ru/v2/informers" }
    
    case getWeatherIn(longitude: Decimal, latitude: Decimal)
    
    var queryItems: [String:String] {
        var queryItemsDict = [String : String]()
        
        switch self {
        case .getWeatherIn(let longitude, let latitude):
            queryItemsDict["lon"] = "\(longitude)"
            queryItemsDict["lat"] = "\(latitude)"
        }
        
        return queryItemsDict
    }
    
    var headers: [String:String] {
      ["X-Yandex-API-Key": apiKey]
    }
    
    var method: HTTPMethod { .get }
}
