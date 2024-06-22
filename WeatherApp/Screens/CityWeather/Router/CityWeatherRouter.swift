import UIKit.UIAlertController

final class CityWeatherRouter: CityWeatherRouterProtocol {
    private let navigationController: ModuleTransitionableProtocol
    
    init(navigationController: ModuleTransitionableProtocol) {
        self.navigationController = navigationController
    }
    
    func showAlert(with title: String, message: String, cancelButtonTitle: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(.init(title: cancelButtonTitle, style: .cancel))
        navigationController.present(module: errorAlert, animated: true)
    }
    
    func hideCurrentModule() {
        navigationController.pop(animated: true)
    }
}
