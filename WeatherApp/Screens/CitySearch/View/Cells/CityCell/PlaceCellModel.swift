import Foundation

final class PlaceCellModel {
    let cityName: String
    let subtitle: String
    var isFavorite: Bool = false
    let latitude: Decimal
    let longitude: Decimal
    let onFavoriteButtonTappedAction: ((PlaceCellModel) -> Void)?
    
    init(cityName: String, 
         subtitle: String,
         isFavorite: Bool = false,
         onFavoriteButtonTappedAction: ((PlaceCellModel) -> Void)?,
         latitude: Decimal,
         longitude: Decimal) {
        self.cityName = cityName
        self.subtitle = subtitle
        self.isFavorite = isFavorite
        self.latitude = latitude
        self.longitude = longitude
        self.onFavoriteButtonTappedAction = onFavoriteButtonTappedAction
    }
}
extension PlaceCellModel {
    convenience init(with persistentObject: GeoObjectPersistent, onFavoriteButtonTappedAction: ((PlaceCellModel) -> Void)?) {
        //TODO: Развернуть нормально
        self.init(cityName: persistentObject.title ?? "", subtitle: persistentObject.subtitle ?? "", isFavorite: true, onFavoriteButtonTappedAction: onFavoriteButtonTappedAction, latitude: persistentObject.latitude?.decimalValue ?? 0, longitude: persistentObject.longitude?.decimalValue ?? 0)
    }
}
