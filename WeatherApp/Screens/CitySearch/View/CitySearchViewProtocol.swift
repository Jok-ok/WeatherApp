import Foundation

protocol CitySearchViewProtocol: AnyObject {
    func setupInitialState(with model: CitySearchViewModel)
    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel)
    func configureSerchedCity(at row: Int, with model: PlaceCellModel) 
    func configureSearchedCitiesTableViewSection(with models: [PlaceCellModel])
    func configureCityTableViewSectionHeader(with text: String)
    func configureFavoriteCitiesTableViewSection(with: [PlaceCellModel])
    func hideFavoriteSection()
    func showFavoriteSection()
    func configureFavoriteSectionHeader(with model: HidebleSectionHeaderModel)
    func insertFavoriteCityInSection(with item: PlaceCellModel)
    func removeFavoriteCityInSection(from row: Int)
}
