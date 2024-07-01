import Foundation

final class GeocoderNetworkService: GeocoderNetworkServiceProtocol {
    func getPlaces(
        for place: String,
        ofKindWith kinds: [GeocodeComponentKind],
        completion: @escaping (Result<[PlaceModelAfterDTO], APIErrors>) -> Void
    ) {
        APINetworkManager.request(
            to: GeocoderAPIEndpoint.getGeoObjectByPrompt(place)) { [weak self] (result: Result<Geocode, APIErrors>) in
            guard let self else { return }
            switch result {
            case .success(let geocodeResponse):
                let placeModels = geoCodeResponseToPlaceModels(response: geocodeResponse)
                completion(.success(placeModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPlace(
        latitude: Decimal,
        longitude: Decimal,
        completion: @escaping (Result<PlaceModelAfterDTO, APIErrors>) -> Void
    ) {
        APINetworkManager.request(to: GeocoderAPIEndpoint.getGeoObjectByCoordinates(
            longitude: longitude,
            latitude: latitude)) { [weak self] (result: Result<Geocode, APIErrors>) in
                guard let self else { return }
                switch result {
                case .success(let geocodeResponse):
                    let placeModels = geoCodeResponseToPlaceModels(response: geocodeResponse)
                    if let geoObject = placeModels.first {
                        completion(.success(geoObject))
                    } else {
                        completion(.failure(.noDataInResponse))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    private func geoCodeResponseToPlaceModels(
        response: Geocode,
        kinds: [GeocodeComponentKind] = []
    ) -> [PlaceModelAfterDTO] {
        if let geoObjects = response.response?.geoObjectCollection?.featureMember?.compactMap({ featureMember in
            if kinds.isEmpty { return featureMember.geoObject }

            if !kinds.isEmpty, kinds.contains(where: { kind in
                featureMember.geoObject?.metaDataProperty?.geocoderMetaData?.kind == kind.rawValue
            }) {
                return featureMember.geoObject
            }
            return nil
        }) {
            let placeModels = geoObjects.compactMap { geoObject in
                let postion = geoObject.point
                let longlat = postion.pos.components(separatedBy: " ")
                if let longitude = Decimal(string: longlat[0]),
                    let latitude = Decimal(string: longlat[1]) {
                    return PlaceModelAfterDTO(
                        name: geoObject.name,
                        descritpion: geoObject.description,
                        longitude: longitude,
                        latitude: latitude,
                        uri: geoObject.uri ?? ""
                    )
                } else { return nil }
            }
            return placeModels
        } else { return [] }
    }
}
