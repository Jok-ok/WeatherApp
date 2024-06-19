import Foundation

final class CitySearchRouter: CitySearchRouterProtocol {
    private let navigationController: ModuleTransitionableProtocol?
    
    init(navigationController: ModuleTransitionableProtocol?) {
        self.navigationController = navigationController
    }
    
    func showWeatherFor(city: String) {
        
    }
}
