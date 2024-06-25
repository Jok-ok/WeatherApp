import Foundation

final class CityWeatherPresenter: CityWeatherPresenterProtocol {
    private weak var view: CityWeatherViewProtocol?
    private var router: CityWeatherRouterProtocol?
    private var weatherNetworkService: WeatherNetworkServiceProtocol?
    private let staticStrings = CityWeatherModuleStaticStrings()
    private var weatherForecastModel: WeatherWithForecastAfterDTO?
    private var currentWeatherCellModel: CurrentWeatherCellModel?
    private let longitude: Decimal
    private let latitude: Decimal
    private let cityName: String
    
    private let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat = "dd.MM.YY\nHH:mm"
        return timeFormatter
    }()
    
    private let dateFormetter: DateFormatter = {
        let datetimeFormatter = DateFormatter()
        datetimeFormatter.dateFormat = "dd.MM"
        return datetimeFormatter
    }()
    
    init(router: CityWeatherRouterProtocol, weatherNetworkService: WeatherNetworkServiceProtocol, longitude: Decimal, latitude: Decimal, cityName: String) {
        self.router = router
        self.weatherNetworkService = weatherNetworkService
        self.longitude = longitude
        self.latitude = latitude
        self.cityName = cityName
    }
    
    func viewDidLoad(with view: CityWeatherViewProtocol) {
        self.view = view
        let cityWeatherViewData = CityWeatherViewData(
            title: self.cityName,
            currentWeatherSectionHeader: staticStrings.currentWeatherSectionHeader,
            dailyForecastWeatherSectionHeader: staticStrings.dailyForecastWeatherSectionHeader,
            hourlyForcastWeatherSectionHeader: staticStrings.hourlyForcastWeatherSectionHeader)
        
        view.setupInitialState(with: cityWeatherViewData)
        requestWeather()
        showCurrentWeather()
    }
    
}
private extension CityWeatherPresenter {
    
    func requestWeather() {
        weatherNetworkService?.getWeatherForecast(longitude: self.longitude, latitude: self.latitude) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let weatherModelAfterDTO):
                self.currentWeatherCellModel = CurrentWeatherCellModel(
                    city: self.cityName,
                    temperatureText: "\(weatherModelAfterDTO.temperature) °C",
                    condition: weatherModelAfterDTO.weatherCondition)
                weatherForecastModel = weatherModelAfterDTO
                showCurrentWeather()
                showHourlyyWeather()
                showDailyWeather()
            case .failure(let error):
                showError(with: error.localizedDescription)
            }
        }
    }
    
    func showCurrentWeather() {
        if let currentWeatherCellModel {
            view?.configureCurrentWeatherSection(with: currentWeatherCellModel)
        } else {
            view?.configureCurrentWeatherSection(
                with: CurrentWeatherCellModel(city: cityName,
                                              temperatureText: staticStrings.undefinedTemeperature,
                                              condition: staticStrings.undefindedCondition))
        }
    }
    
    func showDailyWeather() {
        guard let weatherForecastModel else { return }
        
        var datasets = [ChartCellModel.DataSet]()
        
        let dailyForecastMaxTemepraturePoints = getChartPoints(from: weatherForecastModel.dailyForecast.times, values: weatherForecastModel.dailyForecast.maxTemperatures, formatter: dateFormetter)
        
        datasets.append(ChartCellModel.DataSet(points: dailyForecastMaxTemepraturePoints, colorSceme: .orange))
        
        
        let dailyForecastMinTemepraturePoints = getChartPoints(from: weatherForecastModel.dailyForecast.times, values: weatherForecastModel.dailyForecast.minTemperatures, formatter: dateFormetter)
        
        
        datasets.append(ChartCellModel.DataSet(points: dailyForecastMinTemepraturePoints, colorSceme: .standart))
        
        let chartCellModel = ChartCellModel(linesDatasets: datasets, title: staticStrings.minMaxTemeperature)
        
        view?.configureDailyWeatherSection(with: [chartCellModel])
    }
    
    func showHourlyyWeather() {
        guard let weatherForecastModel else { return }
        
        var datasets = [ChartCellModel.DataSet]()

        let hourlyForecasTemepraturePoints = getChartPoints(from: weatherForecastModel.hourlyForecast.times, values: weatherForecastModel.hourlyForecast.temperature, formatter: timeFormatter)
        
        let hourlyForecasPreciptationProbabilytyPoints = getChartPoints(
            from: weatherForecastModel.hourlyForecast.times,
            values: weatherForecastModel.hourlyForecast.precipitationProbability.map({ Double($0) }), 
            formatter: timeFormatter)
        
        datasets.append(ChartCellModel.DataSet(points: hourlyForecasTemepraturePoints, colorSceme: .standart))
        
        let temperaTureChartCellModel = ChartCellModel(linesDatasets: datasets, title: staticStrings.temperature)
        datasets.removeAll()
        datasets.append(ChartCellModel.DataSet(points: hourlyForecasPreciptationProbabilytyPoints, colorSceme: .standart))
        let preceptationProbability = ChartCellModel(linesDatasets: datasets, title: staticStrings.preceptationProbability)
        
        view?.configureHourlyWeatherSection(with: [temperaTureChartCellModel, preceptationProbability])
    }
    
    func getChartPoints(from time: [Date], values: [Double], formatter: DateFormatter) -> [ChartCellModel.DataSet.Point] {
        let dailyForecastX =  time.map({ formatter.string(from: $0) })
        let dailyForecastY = values
        let zippedValues = zip(dailyForecastX, dailyForecastY)
        
        let points = zippedValues.map({ ChartCellModel.DataSet.Point(x: $0, y: $1) })
        
        return points
    }
    
    func showError(with message: String) {
        router?.showAlert(with: staticStrings.errorAlertControllerTitle, message: message, cancelButtonTitle: staticStrings.errorCancelButtonText)
    }

}
