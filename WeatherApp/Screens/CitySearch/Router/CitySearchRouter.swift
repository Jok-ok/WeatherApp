import Foundation
import UIKit.UIAlertController

final class CitySearchRouter: CitySearchRouterProtocol {
    private let navigationController: ModuleTransitionableProtocol?
    
    init(navigationController: ModuleTransitionableProtocol?) {
        self.navigationController = navigationController
    }
    
    func showWeatherFor(city: String, latitude: Decimal, longitude: Decimal) {
        
    }
    
    func showError(with title: String, message: String, cancelButtonTitle: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(.init(title: cancelButtonTitle, style: .cancel))
        navigationController?.present(module: errorAlert, animated: true)
    }
}
