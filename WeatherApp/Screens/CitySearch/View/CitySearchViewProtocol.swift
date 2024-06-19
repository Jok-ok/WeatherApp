import Foundation

protocol CitySearchViewProtocol: AnyObject {
    func setupInitialState(with model: CitySearchViewModel)
    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel)
    func configureCitiesTableViewSection(with models: [CityCellModel])
    func configureCityTableViewSectionHeader(with text: String)
}
