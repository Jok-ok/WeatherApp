import Foundation

final class CitySearchPresenter {
    
    private let router: CitySearchRouter
    private weak var view: CitySearchViewProtocol?
    
    private let geocoderService: GeocoderNetworkServiceProtocol
    private var locationService: LocationServiceProtocol
    private let geoObjectPersistenceService: GeoObjectServiceProtocol
    private let weatherNetworkService: WeatherNetworkServiceProtocol
    
    private var timer: Timer?
    
    private let staticStrings = CitySearchViewStaticStrings()
    private var currentWeather: CurrentWeatherCellModel?
    private var searchedCitiesCellModels = [PlaceCellModel]()
    private var favoriteCitiesCellModels = [PlaceCellModel]()
    private var isFavoriteSectionHided: Bool = false
    
    init(router: CitySearchRouter, weatherService: WeatherNetworkServiceProtocol, locationService: LocationServiceProtocol, geocoderNetworkService: GeocoderNetworkServiceProtocol, geoObjectPersistenceService: GeoObjectServiceProtocol) {
        self.router = router
        self.locationService = locationService
        self.geocoderService = geocoderNetworkService
        self.geoObjectPersistenceService = geoObjectPersistenceService
        self.weatherNetworkService = weatherService
        self.locationService.delegate = self
    }
}

//MARK: - CitySearchPresenter protocol
extension CitySearchPresenter: CitySearchPresenterProtocol {
    func viewDidLoad(with view: CitySearchViewProtocol) {
        self.view = view
        
        locationService.startUpdatingLocation()
        
        fetchFavoritePersistentGeoObjects()
        
        var favoriteSectionHeaderText = staticStrings.favoriteSectionShowedTitle
        
        if favoriteCitiesCellModels.isEmpty {
            favoriteSectionHeaderText = staticStrings.favoriteSectionEmptyTitle
        }
        
        let favoriteSectionModel = HidebleSectionHeaderModel(headerText: favoriteSectionHeaderText,
                                                             onEyeTappedAction: {[weak self] in self?.hideFavoriteSectionButtonDidTapped() })
        
        let currentWeatherSectionHeader = SectionHeaderModel(headerText: staticStrings.currentWeatherSectionHeader)
        let searchCitySectionHeader = SectionHeaderModel(headerText: staticStrings.greetingSearchCitySectionHeader)
        
        let viewData = CitySearchViewModel(with: staticStrings,
                                           favoriteSectionHeader: favoriteSectionModel,
                                           currentWeatherSectionHeader: currentWeatherSectionHeader,
                                           searchCitySectionHeader: searchCitySectionHeader)
        
        view.setupInitialState(with: viewData)
        view.configureCurrentWeatherSection(with: CurrentWeatherCellModel(city: staticStrings.undefinedLocation, temperatureText:staticStrings.undefinedTemeperature, condition: staticStrings.undefinedTemeperature))
        view.configureFavoriteCitiesTableViewSection(with: self.favoriteCitiesCellModels)
    }
    
    func searchQueryDidUpdated(with text: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            
            if text == "" { return }
            
            self?.geocoderService.getPlaces(for: text, ofKindWith: [.locality, .province]) { result in
                switch result {
                case .success(let placeModels):
                    self?.placeSuggestsInView(placeModels: placeModels)
                case .failure(let error):
                    self?.showError(with: error.localizedDescription)
                }
            }
        })
    }
    
    func refreshViewController() {
        getCurrentWeatherInCurrentLocation()
    }
    
    func onCityDidTapped(model: PlaceCellModel) {
        router.showWeatherFor(city: model.cityName, latitude: model.latitude, longitude: model.longitude)
    }
    
    func onCurrentCityDidTapped() {
        if let location = locationService.getLocation(), let city = currentWeather?.city, city != staticStrings.undefinedLocation {
            router.showWeatherFor(city: city, latitude: Decimal(location.latitude), longitude: Decimal(location.longitude))
        } else {
            showError(with: staticStrings.noCurrentLocationData)
        }
    }
}

//MARK: - Private methods
private extension CitySearchPresenter {
    private func setCurrentWeatherCell() {
        guard let currentWeather else { return }
        view?.configureCurrentWeatherSection(with: currentWeather)
    }
    
    private func fetchFavoritePersistentGeoObjects() {
        self.favoriteCitiesCellModels = geoObjectPersistenceService.fetchGeoObjects().map({ [weak self] geoObject in
            PlaceCellModel(with: geoObject) { [weak self] model in
                self?.onFavoriteButtonDidTapped(model: model)
            }
        })
    }
    
    private func saveToPersistentGeoObject(title: String, subtitle: String, longitude: Decimal, latitude: Decimal ) {
        geoObjectPersistenceService.createGeoObject(title: title, subtitle: subtitle, longitude: longitude, latitude: latitude)
    }
    
    private func deleteFromPersistentStorage(title: String, subtitle: String) {
        geoObjectPersistenceService.deleteGeoObject(with: title, subtitle: subtitle)
    }
    
    private func placeSuggestsInView(placeModels: [PlaceModelAfterDTO]) {
        let staticStrings = CitySearchViewStaticStrings()
        self.view?.configureCityTableViewSectionHeader(with: staticStrings.searchCitySectionHeader)
        self.searchedCitiesCellModels = placeModels.compactMap({ placeModel in
            PlaceCellModel(cityName: placeModel.name, subtitle: placeModel.descritpion ?? "", onFavoriteButtonTappedAction: { [weak self] model in
                self?.onFavoriteButtonDidTapped(model: model)
            }, latitude: placeModel.latitude, longitude: placeModel.longitude)
        })
        self.view?.configureSearchedCitiesTableViewSection(with: self.searchedCitiesCellModels)
    }
    
    private func onFavoriteButtonDidTapped(model: PlaceCellModel) -> Void {
        if model.isFavorite {
            saveToPersistentGeoObject(title: model.cityName, subtitle: model.subtitle, longitude: model.longitude, latitude: model.latitude)
            favoriteCitiesCellModels.insert(model, at: 0)
            view?.insertFavoriteCityInSection(with: model)
        } else {
            let favoriteCityIndex = favoriteCitiesCellModels.firstIndex(where: { ($0.cityName == model.cityName) && ($0.subtitle == model.subtitle) })
            
            if let favoriteCityIndex {
                view?.removeFavoriteCityInSection(from: favoriteCityIndex)
            }
            
            favoriteCitiesCellModels.removeAll(where: { ($0.cityName == model.cityName) && ($0.subtitle == model.subtitle) })
            deleteFromPersistentStorage(title: model.cityName, subtitle: model.subtitle)
            
            
            let searchCityIndex = searchedCitiesCellModels.firstIndex(where: { ($0.cityName == model.cityName) && ($0.subtitle == model.subtitle) })
            
            if let searchCityIndex {
                view?.configureSerchedCity(at: searchCityIndex, with: model)
            }
        }
    }
    
    private func hideFavoriteSectionButtonDidTapped() {
        
        isFavoriteSectionHided.toggle()
        
        let staticStrings = CitySearchViewStaticStrings()
        
        var favoriteSectionHeaderText = staticStrings.favoriteSectionShowedTitle
        
        if isFavoriteSectionHided {
            favoriteSectionHeaderText = staticStrings.favoriteSectionHidedTitle
        } else if favoriteCitiesCellModels.isEmpty {
            favoriteSectionHeaderText = staticStrings.favoriteSectionEmptyTitle
        }
        
        let favoriteSectionModel = HidebleSectionHeaderModel(headerText: favoriteSectionHeaderText,
                                                             onEyeTappedAction: {[weak self] in self?.hideFavoriteSectionButtonDidTapped() })
        
        view?.configureFavoriteSectionHeader(with: favoriteSectionModel)
        
        if isFavoriteSectionHided {
            view?.hideFavoriteSection()
        } else {
            view?.showFavoriteSection()
        }
    }
    
    private func getCurrentWeatherInCurrentLocation() {
        if let location = locationService.getLocation() {
            let latitude = Decimal(location.latitude)
            let longitude = Decimal(location.longitude)
            weatherNetworkService.getWeatherIn(longitude: longitude, latitude: latitude) { [weak self] result in
                switch result {
                case .success(let weather):
                    let temperatureText = "\(weather.temperature) °C"
                    self?.currentWeather?.temperatureText = temperatureText
                    self?.currentWeather?.condition = weather.weatherCondition
                    self?.setCurrentWeatherCell()
                case .failure(let error):
                    self?.showError(with: error.localizedDescription)
                }
                self?.view?.endRefreshViewController()
            }
        } else {
            self.view?.endRefreshViewController()
            showError(with: staticStrings.noCurrentLocationDataForRefresh)
        }
    }
    private func showError(with message: String) {
        router.showError(with: staticStrings.errorAlertControllerTitle, message: message, cancelButtonTitle: staticStrings.errorCancelButtonText)
    }
}

//MARK: - LocationService delegate
extension CitySearchPresenter: LocationServiceDelegate {
    func didUpdateLocation() {
        let location = locationService.getLocation()
        if let location {
            geocoderService.getPlace(latitude: Decimal(location.latitude),
                                     longitude: Decimal(location.longitude))
            { [weak self] result in
                switch result {
                case .success(let geoObject):
                    let name = geoObject.name
                    self?.currentWeather = CurrentWeatherCellModel(city: name, temperatureText: "", condition: "")
                case .failure(let error):
                    self?.showError(with: error.localizedDescription)
                    return
                }
                self?.getCurrentWeatherInCurrentLocation()
            }
            locationService.stopUpdationgLocation()
            
        }
    }
}
