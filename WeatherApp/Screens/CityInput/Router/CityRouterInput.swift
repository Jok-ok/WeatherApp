import UIKit

protocol CityRouterInput {
    
    func showWeatherModule(for city: String)
    
    func showErrorMessageAlert(with message: String)
}
