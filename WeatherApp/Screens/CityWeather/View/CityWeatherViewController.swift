import UIKit
import Charts

class CityWeatherViewController: UITableViewController {
    private var presenter: CityWeatherPresenterProtocol
    private lazy var tableViewAdapter = TableViewAdapter(tableView: tableView)
    private lazy var currentWeatherSection = TableViewSection<CurrentWeatherTableViewCell>()
    private lazy var dailyWeatherSection = TableViewSection<ChartTableViewCell>()
    private lazy var hourlyWeatherSection = TableViewSection<ChartTableViewCell>()

    init(presenter: CityWeatherPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .insetGrouped)
        configureApperance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(with: self)
    }

}

// MARK: - CityWeatherViewProtocol
extension CityWeatherViewController: CityWeatherViewProtocol {
    func setupInitialState(with model: CityWeatherViewData) {
        title = model.title

        setupTableViewInitialState(
            with: model.currentWeatherSectionHeader,
            dailyForcastSectionHeader: model.dailyForecastWeatherSectionHeader,
            hourlyForecastSectionHeader: model.hourlyForcastWeatherSectionHeader)
    }

    private func setupTableViewInitialState(with currentWeatherSectionHeader: String,
                                            dailyForcastSectionHeader: String,
                                            hourlyForecastSectionHeader: String) {
        tableViewAdapter.register(cellType: CurrentWeatherTableViewCell.self)
        tableViewAdapter.register(cellType: ChartTableViewCell.self)
        tableViewAdapter.register(headerFooterType: SectionHeaderView.self)

        let headerSection = SectionHeaderModel(headerText: currentWeatherSectionHeader)
        let dailyForecastSectionHeader = SectionHeaderModel(headerText: dailyForcastSectionHeader)
        let hourlyForecastSectionHeader = SectionHeaderModel(headerText: hourlyForecastSectionHeader)

        let currentWeatherHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: headerSection)

        let dailySectionHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: dailyForecastSectionHeader)

        let hourlySectionHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: hourlyForecastSectionHeader)

        currentWeatherSection.setHeaderCell(with: currentWeatherHeader)
        dailyWeatherSection.setHeaderCell(with: dailySectionHeader)
        hourlyWeatherSection.setHeaderCell(with: hourlySectionHeader)

        tableViewAdapter.append(section: currentWeatherSection)
        tableViewAdapter.append(section: hourlyWeatherSection)
        tableViewAdapter.append(section: dailyWeatherSection)
    }

    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel) {
        currentWeatherSection.items = [model]
        tableViewAdapter.reloadSection(0)
    }

    func configureHourlyWeatherSection(with models: [ChartCellModel]) {
        hourlyWeatherSection.items = models
        tableViewAdapter.reloadSection(1)
    }

    func configureDailyWeatherSection(with models: [ChartCellModel]) {
        dailyWeatherSection.items = models
        tableViewAdapter.reloadSection(2)
    }
}

// MARK: - Appearance

private extension CityWeatherViewController {
    func configureApperance() {
        view.backgroundColor = .getAppColor(.backgroundColor)
    }
}
