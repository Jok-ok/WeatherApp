import UIKit

class CityWeatherViewController: UIViewController, CityWeatherViewInput {
    var output: CityWeatherViewOutput?

    func setupInitialState(with model: CityWeatherPresenterModel) {
        configureApperance(with: model)
    }
}

//MARK: - Appearance

private extension CityWeatherViewController {
    func configureApperance(with model: CityWeatherPresenterModel) {
        
    }
}
