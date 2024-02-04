import UIKit

final class CityModuleConfigurator {
    func configure(output: CityModuleOutput? = nil) -> CityViewController {
        let view = CityViewController()
        let router = CityRouter()
        let presenter = CityPresenter()
        let suggestNetworkService = SuggestNetworkService()
        
        presenter.suggestNetworkService = suggestNetworkService
        presenter.view = view
        presenter.router = router
        presenter.output = output
        router.view = view
        
        view.output = presenter
        
        return view
    }
}

