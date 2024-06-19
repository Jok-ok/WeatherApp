import Foundation

final class CitySearchPresenter: CitySearchPresenterProtocol {
    private let router: CitySearchRouter
    private let suggestService: SuggestNetworkServiceProtocol
    private let locationService: LocationServiceProtocol
    private var timer: Timer?
    private weak var view: CitySearchViewProtocol?
    
    init(router: CitySearchRouter, suggestService: SuggestNetworkServiceProtocol, locationService: LocationServiceProtocol) {
        self.router = router
        self.suggestService = suggestService
        self.locationService = locationService
    }
    
    func viewDidLoad(with view: CitySearchViewProtocol) {
        self.view = view
        
        let staticStrings = CitySearchViewStaticStrings()
        
        let currentWeather = CurrentWeatherCellModel(city: "Мурино", temperatureText: "+14°С")
        
        let viewData = CitySearchViewModel(with: staticStrings, currentWeatherModel: currentWeather)
        
        view.setupInitialState(with: viewData)
    }
    
    func searchQueryDidUpdated(with text: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            
            if text == "" { return }
            
            self?.suggestService.getSuggests(for: text, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let suggests):
                        let staticStrings = CitySearchViewStaticStrings()
                        self?.view?.configureCityTableViewSectionHeader(with: staticStrings.searchCitySectionHeader)
                        let cityCellModels = suggests.map({ CityCellModel(cityName: $0.title.text, subtitle: $0.subtitle?.text ?? "" ) })
                        self?.view?.configureCitiesTableViewSection(with: cityCellModels)
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                    }
                }
            })
        })
    }
}
