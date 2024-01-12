import UIKit

final class CityModuleConfigurator {
    func configure(output: CityModuleOutput? = nil) -> CityViewController {
        let view = CityViewController()
        let router = CityRouter()
        let presenter = CityPresenter()
        
        presenter.view = view
        presenter.router = router
        presenter.output = output
        
        view.output = presenter
        
        return view
    }
}

