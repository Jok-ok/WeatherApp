import UIKit

class CityRouter: CityRouterInput { 
    var view: UIViewController?
    
    func showWeatherModule(for city: String) {
        
    }
    
    func showErrorMessageAlert(with message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "ОК", style: .cancel))
        view?.present(alert, animated: true)
    }
}
