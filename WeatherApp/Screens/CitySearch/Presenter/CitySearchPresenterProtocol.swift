import Foundation

protocol CitySearchPresenterProtocol {
    func viewDidLoad(with: CitySearchViewProtocol)

    func searchQueryDidUpdated(with text: String)

    func refreshViewController()

    func onCityDidTapped(model: PlaceCellModel)

    func onCurrentCityDidTapped()
}
