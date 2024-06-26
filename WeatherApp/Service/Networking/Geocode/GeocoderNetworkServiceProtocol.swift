import Foundation

protocol GeocoderNetworkServiceProtocol {
    func getPlaces(for place: String, ofKindWith kinds: [GeocodeComponentKind], completion: @escaping (Result<[PlaceModelAfterDTO], APIErrors>) -> ())
    func getPlace(latitude: Decimal, longitude: Decimal, completion: @escaping (Result<PlaceModelAfterDTO, APIErrors>) -> ())
}
