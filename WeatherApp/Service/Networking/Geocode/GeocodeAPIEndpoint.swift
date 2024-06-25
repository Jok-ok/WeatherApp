import Foundation

enum GeocoderAPIEndpoint: APIEndpointProtocol {
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    private var apiKey: String { ApiKeys.geocoderApiKey }
    var urlString: String { "https://geocode-maps.yandex.ru/1.x" }
    
    case getGeoObjectByPrompt(String)
    case getGeoObjectByCoordinates(longitude: Decimal, latitude: Decimal)
    
    var queryItems: [String:String] {
        var queryItemsDict = ["apikey": apiKey,
                              "format": "json",
                              "results": "10",
                              "kind":"locality",
                              "lang": "ru_RU"]
        switch self {
        case .getGeoObjectByPrompt(let prompt):
            queryItemsDict["geocode"] = prompt
        case .getGeoObjectByCoordinates(let longitude, let latitude):
            queryItemsDict["geocode"] = "\(longitude), \(latitude)"
        }
        return queryItemsDict
    }
}
