import Foundation

// MARK: - Geocode
struct Geocode: Codable {
    let response: GeocodeResponse?
}

// MARK: - Response
struct GeocodeResponse: Codable {
    let geoObjectCollection: GeoObjectCollection?

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let metaDataProperty: GeoObjectCollectionMetaDataProperty?
    let featureMember: [FeatureMember]?
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject?

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let metaDataProperty: GeoObjectMetaDataProperty?
    let name: String
    let description: String?
    let boundedBy: BoundedBy?
    let uri: String?
    let point: Point

    enum CodingKeys: String, CodingKey {
        case metaDataProperty, name, description, boundedBy, uri
        case point = "Point"
    }
}

// MARK: - BoundedBy
struct BoundedBy: Codable {
    let envelope: Envelope?

    enum CodingKeys: String, CodingKey {
        case envelope = "Envelope"
    }
}

// MARK: - Envelope
struct Envelope: Codable {
    let lowerCorner, upperCorner: String?
}

// MARK: - GeoObjectMetaDataProperty
struct GeoObjectMetaDataProperty: Codable {
    let geocoderMetaData: GeocoderMetaData?

    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }
}

// MARK: - GeocoderMetaData
struct GeocoderMetaData: Codable {
    let precision, text, kind: String?
    let address: GeoCodeAddress?
    let addressDetails: AddressDetails?

    enum CodingKeys: String, CodingKey {
        case precision, text, kind
        case address = "Address"
        case addressDetails = "AddressDetails"
    }
}

// MARK: - Address
struct GeoCodeAddress: Codable {
    let countryCode, formatted: String?
    let components: [GeocodeComponent]?

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case formatted
        case components = "Components"
    }
}

// MARK: - Component
struct GeocodeComponent: Codable {
    let kind: GeocodeComponentKind
    let name: String
}

enum GeocodeComponentKind: String, Codable, CodingKey {
    case country
    case province
    case area
    case locality
    case vegetation
    case railwayStation = "railway_station"
    case station
    case street
    case house
    case hydro
    case district
    case metro
    case region
    case airport
    case route
    case other
}

// MARK: - AddressDetails
struct AddressDetails: Codable {
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case country = "Country"
    }
}

// MARK: - Country
struct Country: Codable {
    let addressLine, countryNameCode, countryName: String?
    let administrativeArea: AdministrativeArea?

    enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case countryNameCode = "CountryNameCode"
        case countryName = "CountryName"
        case administrativeArea = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let administrativeAreaName: String?
    let subAdministrativeArea: SubAdministrativeArea?

    enum CodingKeys: String, CodingKey {
        case administrativeAreaName = "AdministrativeAreaName"
        case subAdministrativeArea = "SubAdministrativeArea"
    }
}

// MARK: - SubAdministrativeArea
struct SubAdministrativeArea: Codable {
    let subAdministrativeAreaName: String?
    let locality: Locality?

    enum CodingKeys: String, CodingKey {
        case subAdministrativeAreaName = "SubAdministrativeAreaName"
        case locality = "Locality"
    }
}

// MARK: - Locality
struct Locality: Codable {
    let localityName: String?

    enum CodingKeys: String, CodingKey {
        case localityName = "LocalityName"
    }
}

// MARK: - Point
struct Point: Codable {
    let pos: String
}

// MARK: - GeoObjectCollectionMetaDataProperty
struct GeoObjectCollectionMetaDataProperty: Codable {
    let geocoderResponseMetaData: GeocoderResponseMetaData?

    enum CodingKeys: String, CodingKey {
        case geocoderResponseMetaData = "GeocoderResponseMetaData"
    }
}

// MARK: - GeocoderResponseMetaData
struct GeocoderResponseMetaData: Codable {
    let request, results, found: String?
}
