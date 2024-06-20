import Foundation

final class GeocoderNetworkService: GeocoderNetworkServiceProtocol {
    func getGeoObject(for place: String, ofKindWith kinds: [GeocodeComponentKind], completion: @escaping (Result<[GeoObject], SuggestAPIErrors>) -> ()) {
        APINetworkManager.request(to: GeocoderAPIEndpoint.getGeoObjectByPrompt(place))
        { (result: Result<Geocode, SuggestAPIErrors>) -> Void in
            switch result {
            case .success(let geocodeResponse):
                if let geoObjects = geocodeResponse.response?.geoObjectCollection?.featureMember?.compactMap({ featureMember in
                    if kinds.contains(where: { kind in
                        featureMember.geoObject?.metaDataProperty?.geocoderMetaData?.kind == kind.rawValue
                    }) {
                        return featureMember.geoObject
                    }
                    return nil
                }) {
                    
                    completion(.success(geoObjects))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getGeoObject(latitude: Decimal, longitude: Decimal, completion: @escaping (Result<GeoObject, SuggestAPIErrors>) -> ()) {
        APINetworkManager.request(to: GeocoderAPIEndpoint.getGeoObjectByCoordinates(longitude: longitude, latitude: latitude)) { (result: Result<Geocode, SuggestAPIErrors>) -> Void in
            switch result {
            case .success(let geocodeResponse):
                if let geoObject = geocodeResponse.response?.geoObjectCollection?.featureMember?.first?.geoObject {
                    completion(.success(geoObject))
                } else {
                    completion(.failure(.noDataInResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
