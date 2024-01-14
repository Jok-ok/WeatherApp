import UIKit

class CityViewController: UIViewController, CityViewInput {
    
    private var cityTextField = StandartTextField()
    private var confirmButton = StandartButton()
    
    var output: CityViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - CityViewInput
    func setupInitialState(model: CityPresenterModel) {
        configureApperance(with: model)
    }
}

// MARK: - Appearance
private extension CityViewController {
    func configureApperance(with model: CityPresenterModel) {
        configureNavigationController(with: model.title)
        self.view.backgroundColor = .white
        
        configureTextField(with: model.cityEntryPlaceholder)
        configureConfirmButton(with: model.confirmButtonTitle)
        
        view.addSubview(cityTextField)
        view.addSubview(confirmButton)
        
        constraintTextField()
        constraintConfirmButton()
    }
    
    func configureNavigationController(with title: String) {
        self.title = title
    }
    
    func configureConfirmButton(with text: String) {
        confirmButton.setTitle(text, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmCity), for: .touchUpInside)
    }
    
    func configureTextField(with placeholder: String) {
        cityTextField.placeholder = placeholder
        cityTextField.setPadding(xInset: 15, yInset: 15)
        cityTextField.addTarget(self, action: #selector(cityTextFieldEdited), for: .editingChanged)
    }
    
    func constraintTextField() {
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            cityTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cityTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            cityTextField.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintConfirmButton() {
        let constraints = [
            confirmButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 25),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Actions
private extension CityViewController {
    @objc func confirmCity() {
        output?.confirmButtonPressed(with: cityTextField.text ?? "")
    }
    
    @objc func cityTextFieldEdited() {
        output?.cityTextFieldEdited(with: cityTextField.text ?? "")
    }
}
