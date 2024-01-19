final class CityPresenter: CityViewOutput, CityModuleInput {
    
    private var city = ""
    
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
        city = prompt
        print(prompt)
        return ["Some", "Data", "For", "Current", "Collection", "View"]
    }
    
}
