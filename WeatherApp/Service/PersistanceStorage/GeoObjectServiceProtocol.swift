import Foundation


protocol GeoObjectServiceProtocol {
    @discardableResult
    func createGeoObject(title: String, subtitle: String, longitude: Decimal, latitude: Decimal) -> GeoObjectPersistent
    func fetchGeoObjects() -> [GeoObjectPersistent]
    func deleteGeoObject(with title: String, subtitle: String)
}
