import Foundation

struct CitySearchViewModel {
    let title: String
    let searchPlaceholder: String
    
    let searchCitySectionHeader: String
    
    let currentWeatherSectionHeader: String

    let searchCancelButtonText: String
    
    let currentWeatherModel: CurrentWeatherCellModel
    
    let cityCellModels: [CityCellModel]
}

extension CitySearchViewModel {
    init(with staticStrings: CitySearchViewStaticStrings, currentWeatherModel: CurrentWeatherCellModel, cityCellModels: [CityCellModel] = []) {
        title = staticStrings.title
        searchPlaceholder = staticStrings.searchPlaceholder
        currentWeatherSectionHeader = staticStrings.currentWeatherSectionHeader
        searchCitySectionHeader = staticStrings.greetingSearchCitySectionHeader
        searchCancelButtonText = staticStrings.searchCancelButtonText
        self.currentWeatherModel = currentWeatherModel
        self.cityCellModels = cityCellModels
    }
}
