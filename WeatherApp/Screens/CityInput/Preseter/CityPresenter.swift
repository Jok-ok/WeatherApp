import Foundation

final class CityPresenter: CityViewOutput, CityModuleInput {
    // MARK: - Private properties
    private var city = ""
    private var timer: Timer?
    
    // MARK: - Public properties
    weak var view: CityViewInput?
    
    var router: CityRouterInput?
    
    var output: CityModuleOutput?
    
    var suggestNetworkService: SuggestNetworkServiceProtocol?
    var locationService: LocationService?
    
    // MARK: - CityViewOutput
    
    func viewDidLoad() {
        view?.setupInitialState(model: CityPresenterModel())
    }
    
    func confirmButtonPressed(with prompt: String) {
        print(prompt)
    }
    
    func cityTextFieldEdited(with prompt: String) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            
            if prompt == "" { return }
            
            self?.city = prompt
            self?.suggestNetworkService?.getSuggests(for: prompt, completion: { [weak self] result in
                
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let suggests):
                        let titles = suggests.map({$0.title.text})
                        let subtitles = suggests.map({$0.subtitle?.text})
                        self?.view?.configureCollectionViewData(with: titles, subtitles: subtitles)
                    case .failure(let error):
                        self?.router?.showErrorMessageAlert(with: error.customDescription)
                    }
                }
            })
        })
    }
}

// MARK: - LocationServiceDelegate
extension CityPresenter: LocationServiceDelegate {
    func didUpdateLocation() {
        
    }
}
