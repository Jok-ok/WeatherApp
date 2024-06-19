import UIKit

final class CitySearchTableViewController: UITableViewController {
    private let presenter: CitySearchPresenterProtocol
    private lazy var searchController = SearchController(searchResultsController: nil, searchResultUpdater: self)
    private lazy var tableViewAdapter = TableViewAdapter(tableView: tableView)
    private lazy var currentWeatherSection = TableViewSection<CurrentWeatherTableViewCell>()
    private lazy var citiesTableViewSection = TableViewSection<CityTableViewCell>()
    
    init(presenter: CitySearchPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .insetGrouped)
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        presenter.viewDidLoad(with: self)
    }
}
//MARK: - CitySearchViewProtocol
extension CitySearchTableViewController: CitySearchViewProtocol {
    func setupInitialState(with model: CitySearchViewModel) {
        title = model.title
        
        configureSearchBar(with: model.searchPlaceholder, clearButtonText: model.searchCancelButtonText)
        
        setupTableViewInitialState(with: SectionHeaderModel(headerText: model.currentWeatherSectionHeader),
                                   cityHeaderViewModel: SectionHeaderModel(headerText: model.searchCitySectionHeader),
                                   currentWeatherCellModel: model.currentWeatherModel)
        
    }
    
    private func setupTableViewInitialState(with weatherHeaderViewModel: SectionHeaderModel,
                                            cityHeaderViewModel: SectionHeaderModel,
                                            currentWeatherCellModel: CurrentWeatherCellModel) {
        tableViewAdapter.register(cellType: CurrentWeatherTableViewCell.self)
        tableViewAdapter.register(headerFooterType: SectionHeaderView.self)
        tableViewAdapter.register(cellType: CityTableViewCell.self)
        
        let currentWeatherHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: weatherHeaderViewModel)
        
        let cityHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: cityHeaderViewModel)
        
        citiesTableViewSection.setHeaderCell(with: cityHeader)
        currentWeatherSection.setHeaderCell(with: currentWeatherHeader)
        
        configureCurrentWeatherSection(with: currentWeatherCellModel)
        
        tableViewAdapter.append(section: currentWeatherSection)
        tableViewAdapter.append(section: citiesTableViewSection)

    }
    
    func configureSearchBar(with placeholder: String, clearButtonText: String) {
        searchController.configure(placeholder: placeholder,
                                   clearButtonText: clearButtonText)
    }
    
    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel) {
        currentWeatherSection.items = [model]
        tableViewAdapter.reloadSection(0)
    }
    
    func configureCitiesTableViewSection(with models: [CityCellModel]) {
        citiesTableViewSection.items = models
        tableViewAdapter.reloadSection(1)
    }
    
    func configureCityTableViewSectionHeader(with text: String) {
        let cityHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: SectionHeaderModel(headerText: text))
        citiesTableViewSection.setHeaderCell(with: cityHeader)
    }
}

//MARK: - Appearance
private extension CitySearchTableViewController {
    func configureAppearance() {
        view.backgroundColor = .getAppColor(.backgroundColor)
        configureNavigationBarAppearance()
        configureTableViewAppearance()
    }

    func configureNavigationBarAppearance() {
        navigationItem.searchController = searchController
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationItem.largeTitleDisplayMode = .always
        
        //TODO: - Вынести в экстеншн
        navigationBarAppearace.titleTextAttributes = [.foregroundColor: UIColor.getAppColor(.accentColor)]
        navigationBarAppearace.largeTitleTextAttributes = [.foregroundColor: UIColor.getAppColor(.accentColor)]
    }
    
    func configureTableViewAppearance() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .getAppColor(.backgroundColor)
    }
}

//MARK: - UISearchResultUpdating
extension CitySearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchQueryDidUpdated(with: searchController.searchBar.searchTextField.text ?? "")
    }
}
