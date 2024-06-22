import Foundation

protocol CityWeatherViewProtocol: AnyObject {
    func setupInitialState(with: CityWeatherViewData)
    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel)
    func configureHourlyWeatherSection(with models: [ChartCellModel])
    func configureDailyWeatherSection(with models: [ChartCellModel])
}
