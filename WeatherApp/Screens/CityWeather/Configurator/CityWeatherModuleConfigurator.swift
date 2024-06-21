final class CityWeatherModuleConfigurator {
    struct Dependecies {
        let weatherService: OpenMeteoNetworkServiceProtocol
    }
    
    func configure(output: CityWeatherModuleOutput? = nil) -> CityWeatherViewController {
        let view = CityWeatherViewController()
        let presenter = CityWeatherPresenter()
        let router = CityWeatherRouter()
        
        presenter.view = view
        presenter.router = router
        presenter.output = output
        
        view.output = presenter
        
        return view
    }
}
