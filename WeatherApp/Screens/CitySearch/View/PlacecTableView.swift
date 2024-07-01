import UIKit

final class PlacecTableView: UITableView {
    lazy var tableViewAdapter = TableViewAdapter(tableView: self)
    lazy var currentWeatherSection = TableViewSection<CurrentWeatherTableViewCell>()
    lazy var citiesTableViewSection = TableViewSection<PlaceTableViewCell>()
    lazy var favoriteTableViewSection = TableViewSection<PlaceTableViewCell>()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlacecTableView {
    func setupTableViewInitialState(with weatherHeaderViewModel: SectionHeaderModel,
                                    cityHeaderViewModel: SectionHeaderModel,
                                    favoriteSectionHeaderModel: HidebleSectionHeaderModel) {

        tableViewAdapter.register(cellType: CurrentWeatherTableViewCell.self)
        tableViewAdapter.register(headerFooterType: SectionHeaderView.self)
        tableViewAdapter.register(cellType: PlaceTableViewCell.self)

        setupFavoriteSection(with: favoriteSectionHeaderModel)
        setupCurrentCitySection(with: weatherHeaderViewModel)
        setupCitiesSection(with: cityHeaderViewModel)
    }

    // MARK: - Sections
    private func setupFavoriteSection(with headerModel: HidebleSectionHeaderModel) {
        let favoriteTableViewSectionHeader = TableViewHeaderFooter<HidebleSectionHeaderView>(cellModel: headerModel)
        favoriteTableViewSection.setHeaderCell(with: favoriteTableViewSectionHeader)
        tableViewAdapter.append(section: favoriteTableViewSection)
    }

    private func setupCurrentCitySection(with headerModel: SectionHeaderModel) {
        let currentWeatherHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: headerModel)
        currentWeatherSection.setHeaderCell(with: currentWeatherHeader)
        tableViewAdapter.append(section: currentWeatherSection)
    }

    private func setupCitiesSection(with headerModel: SectionHeaderModel) {
        let cityHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: headerModel)
        citiesTableViewSection.setHeaderCell(with: cityHeader)
        tableViewAdapter.append(section: citiesTableViewSection)
    }
}

// MARK: - Appearance
private extension PlacecTableView {
    func configureAppearance() {
        separatorStyle = .none
        backgroundColor = .getAppColor(.backgroundColor)
    }
}
