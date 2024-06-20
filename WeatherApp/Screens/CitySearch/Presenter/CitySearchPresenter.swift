import Foundation

final class CitySearchPresenter: CitySearchPresenterProtocol {
    private let router: CitySearchRouter
    private let suggestService: SuggestNetworkServiceProtocol
    private let geocoderService: GeocoderNetworkServiceProtocol
    private var locationService: LocationServiceProtocol
    private let geoObjectPersistenceService: GeoObjectServiceProtocol
    private var timer: Timer?
    private weak var view: CitySearchViewProtocol?
    private var searchedCitiesCellModels = [PlaceCellModel]()
    private var favoriteCitiesCellModels = [PlaceCellModel]()
    private var isFavoriteSectionHided: Bool = false
    
    init(router: CitySearchRouter, suggestService: SuggestNetworkServiceProtocol, locationService: LocationServiceProtocol, geocoderNetworkService: GeocoderNetworkServiceProtocol, geoObjectPersistenceService: GeoObjectServiceProtocol) {
        self.router = router
        self.suggestService = suggestService
        self.locationService = locationService
        self.geocoderService = geocoderNetworkService
        self.geoObjectPersistenceService = geoObjectPersistenceService
        self.locationService.delegate = self
    }
    
    func viewDidLoad(with view: CitySearchViewProtocol) {
        self.view = view
        
        let staticStrings = CitySearchViewStaticStrings()
        
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
        view.configureFavoriteCitiesTableViewSection(with: self.favoriteCitiesCellModels)
    }
    
    private func setCurrentLocationValue(with city: String, temperature: String) {
        let currentWeather = CurrentWeatherCellModel(city: city, temperatureText: temperature)
        view?.configureCurrentWeatherSection(with: currentWeather)
    }
    
    func searchQueryDidUpdated(with text: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            
            if text == "" { return }
            
            self?.geocoderService.getGeoObject(for: text, ofKindWith: [.locality, .province]) { result in
                guard let self else { return }
                
                switch result {
                case .success(let geoObjects):
                    self.placeSuggestsInView(geoObjects: geoObjects)
                case .failure(let error):
                    self.showError(errorDescription: error.localizedDescription)
                }
            }
        })
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

    private func placeSuggestsInView(geoObjects: [GeoObject]) {
        let staticStrings = CitySearchViewStaticStrings()
        self.view?.configureCityTableViewSectionHeader(with: staticStrings.searchCitySectionHeader)
        self.searchedCitiesCellModels = geoObjects.compactMap({ geoObject in
            let postion = geoObject.point
            let longlat = postion.pos.components(separatedBy: " ")
            if let longitude = Decimal(string: longlat[0]), let latitude = Decimal(string: longlat[1]) {
                return PlaceCellModel(cityName: geoObject.name,
                              subtitle: geoObject.description ?? "",
                              isFavorite: self.favoriteCitiesCellModels.contains(where: {
                    model in (geoObject.name == model.cityName) && (geoObject.description ?? "" == model.subtitle)
                }),
                              onFavoriteButtonTappedAction: { [weak self] model in
                    self?.onFavoriteButtonDidTapped(model: model)
                }, latitude: latitude, longitude: longitude)
            } else { return nil }
        })
        self.view?.configureSearchedCitiesTableViewSection(with: self.searchedCitiesCellModels)
    }
    
    private func showError(errorDescription: String) {
        print("\(errorDescription)")
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
    
}


extension CitySearchPresenter: LocationServiceDelegate {
    func didUpdateLocation() {
        let location = locationService.getLocation()
        if let location {
            geocoderService.getGeoObject(latitude: Decimal(location.latitude),
                                         longitude: Decimal(location.longitude)) { [weak self] result in
                switch result {
                case .success(let geoObject):
                    let name = geoObject.name
                    self?.setCurrentLocationValue(with: name, temperature: "--")
                case .failure(let error):
                    self?.setCurrentLocationValue(with: "Неизвестно", temperature: "--")
                }
            }
            locationService.stopUpdationgLocation()
        }
        
    }
}
