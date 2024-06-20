import Foundation

protocol GeocoderNetworkServiceProtocol {
    func getGeoObject(for place: String, ofKindWith kinds: [GeocodeComponentKind], completion: @escaping (Result<[GeoObject], SuggestAPIErrors>) -> ())
    func getGeoObject(latitude: Decimal, longitude: Decimal, completion: @escaping (Result<GeoObject, SuggestAPIErrors>) -> ())
}
