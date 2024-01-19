final class CityWeatherPresenter: CityWeatherViewOutput, CityWeatherModuleInput {
    
    weak var view: CityWeatherViewInput?
    var router: CityWeatherRouterInput?
    var output: CityWeatherModuleOutput?

    func viewDidLoad() {
        view?.setupInitialState(with: CityWeatherPresenterModel())
    }

}
