import UIKit

final class CitySearchTableViewController: UITableViewController {
    private let presenter: CitySearchPresenterProtocol
    private lazy var searchController = SearchController(searchResultsController: nil, searchResultUpdater: self)
    private lazy var customTableView: PlacecTableView = PlacecTableView(frame: .zero, style: .insetGrouped)
    
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
        self.tableView = customTableView
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
                                   favoriteSectionHeaderModel: model.favoriteSectionHeader)
        configureRefreshControl()
    }
    
    func endRefreshViewController() {
        refreshControl?.endRefreshing()
    }
    
    func configureSearchBar(with placeholder: String, clearButtonText: String) {
        searchController.configure(placeholder: placeholder,
                                   clearButtonText: clearButtonText)
        navigationItem.searchController = searchController
    }
    
    func configureCurrentWeatherSection(with model: CurrentWeatherCellModel) {
        customTableView.currentWeatherSection.items = [model]
        customTableView.tableViewAdapter.reloadSection(1)
    }
    
    func configureSerchedCity(at row: Int, with model: PlaceCellModel) {
        customTableView.citiesTableViewSection.items[row] = model
        customTableView.tableViewAdapter.reloadRow(at: 2, row: row)
    }
    
    func configureSearchedCitiesTableViewSection(with models: [PlaceCellModel]) {
        customTableView.citiesTableViewSection.items = models
        customTableView.tableViewAdapter.reloadSection(2)
    }
    
    func configureCityTableViewSectionHeader(with text: String) {
        let cityHeader = TableViewHeaderFooter<SectionHeaderView>(cellModel: SectionHeaderModel(headerText: text))
        customTableView.citiesTableViewSection.setHeaderCell(with: cityHeader)
    }
    
    func configureFavoriteCitiesTableViewSection(with items: [PlaceCellModel]) {
        customTableView.favoriteTableViewSection.items = items
        customTableView.tableViewAdapter.reloadSection(0)
    }
    
    func insertFavoriteCityInSection(with item: PlaceCellModel) {
        customTableView.favoriteTableViewSection.items.insert(item, at: 0)
        customTableView.tableViewAdapter.insertRow(at: 0, row: 0)
    }
    
    func removeFavoriteCityInSection(from row: Int) {
        customTableView.favoriteTableViewSection.items.remove(at: row)
        customTableView.tableViewAdapter.removeRow(at: 0, row: row)
    }
    
    func endEditingSearchBar() {
        searchController.searchBar.endEditing(true)
    }
    
    func hideFavoriteSection() {
        customTableView.tableViewAdapter.hideSection(with: 0)
        customTableView.tableViewAdapter.reloadSection(0)
    }
    
    func showFavoriteSection() {
        customTableView.tableViewAdapter.showSection(with: 0)
        customTableView.tableViewAdapter.reloadSection(0)
    }
    
    func configureFavoriteSectionHeader(with model: HidebleSectionHeaderModel) {
        let favoriteTableViewSectionHeader = TableViewHeaderFooter<HidebleSectionHeaderView>(cellModel: model)
        customTableView.favoriteTableViewSection.setHeaderCell(with: favoriteTableViewSectionHeader)
    }
}

//MARK: - Appearance
private extension CitySearchTableViewController {
    func configureAppearance() {
        view.backgroundColor = .getAppColor(.backgroundColor)
        configureNavigationBarAppearance()
    }
    
    func configureNavigationBarAppearance() {
        navigationController?.navigationBar.setTitleTextColor(.getAppColor(.accentColor))
    }
}

//MARK: - TableView
private extension CitySearchTableViewController {
    func setupTableViewInitialState(with weatherHeaderViewModel: SectionHeaderModel,
                                    cityHeaderViewModel: SectionHeaderModel,
                                    favoriteSectionHeaderModel: HidebleSectionHeaderModel) {
        
        customTableView.setupTableViewInitialState(with: weatherHeaderViewModel, cityHeaderViewModel: cityHeaderViewModel, favoriteSectionHeaderModel: favoriteSectionHeaderModel)
        bindSectionActions()
    }
    
    func bindSectionActions() {
        customTableView.favoriteTableViewSection.setTapHandler { [weak self] model in
            self?.presenter.onCityDidTapped(model: model)
        }
        customTableView.currentWeatherSection.setTapHandler { [weak self] _ in
            self?.presenter.onCurrentCityDidTapped()
        }
        customTableView.citiesTableViewSection.setTapHandler { [weak self] model in
            self?.presenter.onCityDidTapped(model: model)
        }
    }
    
    //MARK: - RefreshControl
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .getAppColor(.accentColor)
        refreshControl?.addTarget(self, action: #selector(refreshViewController), for: .valueChanged)
    }
    
    @objc func refreshViewController() {
        presenter.refreshViewController()
    }
}

//MARK: - UISearchResultUpdating
extension CitySearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchQueryDidUpdated(with: searchController.searchBar.searchTextField.text ?? "")
    }
}
