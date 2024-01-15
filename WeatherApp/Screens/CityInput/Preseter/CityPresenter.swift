import Foundation

final class CityPresenter: CityViewOutput, CityModuleInput {
    
    var city = ""
    
    weak var view: CityViewInput?
    
    var router: CityRouterInput?
    
    var output: CityModuleOutput?
    
    func viewDidLoad() {
        view?.setupInitialState(model: CityPresenterModel())
    }
    
    func confirmButtonPressed(with prompt: String) {
        print(prompt)
    }
    
    func cityTextFieldEdited(with prompt: String) -> [String] {
        print(prompt)
        return ["Some", "Data", "For", "Current", "Collection", "View"]
    }
    
}
