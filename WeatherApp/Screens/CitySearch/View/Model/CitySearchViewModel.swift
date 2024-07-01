import Foundation

struct CitySearchViewModel {
    let title: String
    let searchPlaceholder: String

    let favoriteSectionHeader: HidebleSectionHeaderModel

    let currentWeatherSectionHeader: SectionHeaderModel

    let searchCitySectionHeader: SectionHeaderModel

    let searchCancelButtonText: String

    let cityCellModels: [PlaceCellModel]
}

extension CitySearchViewModel {
    init(with staticStrings: CitySearchViewStaticStrings,
         favoriteSectionHeader: HidebleSectionHeaderModel,
         currentWeatherSectionHeader: SectionHeaderModel,
         searchCitySectionHeader: SectionHeaderModel,
         cityCellModels: [PlaceCellModel] = []) {

        title = staticStrings.title
        searchPlaceholder = staticStrings.searchPlaceholder
        searchCancelButtonText = staticStrings.searchCancelButtonText

        self.favoriteSectionHeader = favoriteSectionHeader
        self.currentWeatherSectionHeader = currentWeatherSectionHeader
        self.searchCitySectionHeader = searchCitySectionHeader

        self.cityCellModels = cityCellModels
    }
}
