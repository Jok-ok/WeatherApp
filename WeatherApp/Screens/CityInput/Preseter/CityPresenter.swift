import Foundation

final class CityPresenter: CityViewOutput, CityModuleInput {
    
    private var city = ""
    
    weak var view: CityViewInput?
    
    var router: CityRouterInput?
    
    var output: CityModuleOutput?
    
    var suggestNetworkService: SuggestNetworkServiceProtocol?
    
    func viewDidLoad() {
        view?.setupInitialState(model: CityPresenterModel())
    }
    
    func confirmButtonPressed(with prompt: String) {
        print(prompt)
    }
    
    func cityTextFieldEdited(with prompt: String) {
        
        city = prompt
        suggestNetworkService?.getSuggests(for: prompt, completion: { [weak self] result in
            
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let suggests):
                    self?.view?.configureCollectionViewData(with: suggests)
                case .failure(let error):
                    self?.router?.showErrorMessageAlert(with: error.customDescription)
                }
            }
        })
    }
    
}
