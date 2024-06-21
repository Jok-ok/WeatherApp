import UIKit

final class CitySearchTableViewController: UITableViewController {
    private let presenter: CitySearchPresenterProtocol
    private lazy var searchController = SearchController(searchResultsController: nil, searchResultUpdater: self)
    private lazy var tableViewAdapter = TableViewAdapter(tableView: tableView)
    private lazy var currentWeatherSection = TableViewSection<CurrentWeatherTableViewCell>()
    private lazy var citiesTableViewSection = TableViewSection<PlaceTableViewCell>()
    private lazy var favoriteTableViewSection = TableViewSection<PlaceTableViewCell>()
    
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
        super.viewDidLoad()
        presenter.viewDidLoad(with: self)
    }
}
//MARK: - CitySearchViewProtocol
extension CitySearchTableViewController: CitySearchViewProtocol {
    func setupInitialState(with model: CitySearchViewModel) {
        title = model.title
        
        configureSearchBar(with: model.searchPlaceholder, clearButtonText: model.searchCancelButtonText)
        
        setupTableViewInitialState(with: model.currentWeatherSectionHeader,
                                   cityHeaderViewModel: model.searchCitySectionHeader,
                                   favoriteSectionViewModel: model.favoriteSectionHeader)
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .getAppColor(.accentColor)
        refreshControl?.addTarget(self, action: #selector(refreshViewController), for: .valueChanged)
        
    }
    
    @objc private func refreshViewController() {
        presenter.refreshViewController()
    }
    
    func endRefreshViewController() {
        refreshControl?.endRefreshing()
    }
    
    private func setupTableViewInitialState(with weatherHeaderViewModel: SectionHeaderModel,
                                            cityHeaderViewModel: SectionHeaderModel,
                                            favoriteSectionViewModel: HidebleSectionHeaderModel) {
        
        favoriteTableViewSection.setTapHandler { [weak self] model in
            self?.cityDidTaped(model: model)
        }
        
        currentWeatherSection.setTapHandler { [weak self] model in
            self?.currentWeatherCellDidTaped(model: model)
        }
        
        citiesTableViewSection.setTapHandler { [weak self] model in
            self?.cityDidTaped(model: model)
        }
        
        tableViewAdapter.register(cellType: CurrentWeatherTableViewCell.self)
        tableViewAdapter.register(headerFooterType: SectionHeaderView.self)
        tableViewAdapter.register(cellType: PlaceTableViewCell.self)
        
        let favoriteTableViewSectionHeader = TableViewHeaderFooter<HidebleSectionHeaderView>(cellModel: favoriteSectionViewModel)
        
        let currentWeatherHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: weatherHeaderViewModel)
        
        let cityHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: cityHeaderViewModel)
        
        favoriteTableViewSection.setHeaderCell(with: favoriteTableViewSectionHeader)
        currentWeatherSection.setHeaderCell(with: currentWeatherHeader)
        citiesTableViewSection.setHeaderCell(with: cityHeader)
        
        tableViewAdapter.append(section: favoriteTableViewSection)
        tableViewAdapter.append(section: currentWeatherSection)
        tableViewAdapter.append(section: citiesTableViewSection)

    }
    
    func configureSearchBar(with placeholder: String, clearButtonText: String) {
        searchController.configure(placeholder: placeholder,
                                   clearButtonText: clearButtonText)
    }
    
    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel) {
        currentWeatherSection.items = [model]
        tableViewAdapter.reloadSection(1)
    }
    
    func configureSerchedCity(at row: Int, with model: PlaceCellModel) {
        citiesTableViewSection.items[row] = model
        tableViewAdapter.reloadRow(at: 2, row: row)
    }
    
    func configureSearchedCitiesTableViewSection(with models: [PlaceCellModel]) {
        citiesTableViewSection.items = models
        tableViewAdapter.reloadSection(2)
    }
    
    func configureCityTableViewSectionHeader(with text: String) {
        let cityHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: SectionHeaderModel(headerText: text))
        citiesTableViewSection.setHeaderCell(with: cityHeader)
    }
    
    func configureFavoriteCitiesTableViewSection(with items: [PlaceCellModel]) {
        favoriteTableViewSection.items = items
        tableViewAdapter.reloadSection(0)
    }
    
    func insertFavoriteCityInSection(with item: PlaceCellModel) {
        favoriteTableViewSection.items.insert(item, at: 0)
        tableViewAdapter.insertRow(at: 0, row: 0)
    }
    
    func removeFavoriteCityInSection(from row: Int) {
        favoriteTableViewSection.items.remove(at: row)
        tableViewAdapter.removeRow(at: 0, row: row)
    }
    
    func hideFavoriteSection() {
        tableViewAdapter.hideSection(with: 0)
        tableViewAdapter.reloadSection(0)
    }
    
    func showFavoriteSection() {
        tableViewAdapter.showSection(with: 0)
        tableViewAdapter.reloadSection(0)
    }
    
    func configureFavoriteSectionHeader(with model: HidebleSectionHeaderModel) {
        let favoriteTableViewSectionHeader = TableViewHeaderFooter<HidebleSectionHeaderView>(cellModel: model)
        favoriteTableViewSection.setHeaderCell(with: favoriteTableViewSectionHeader)
    }
}

private extension CitySearchTableViewController {
    func cityDidTaped(model: PlaceCellModel) {
        presenter.onCityDidTapped(model: model)
    }
    
    func currentWeatherCellDidTaped(model: CurrentWeatherCellModel) {
        presenter.onCurrentCityDidTapped()
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
