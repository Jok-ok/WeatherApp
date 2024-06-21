import UIKit

class CityWeatherViewController: UITableViewController, CityWeatherViewInput {
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
