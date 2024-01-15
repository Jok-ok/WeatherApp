import UIKit

class CityViewController: UIViewController, CityViewInput {
    
    private var cityTextField = StandartTextField()
    private var confirmButton = StandartButton()
    private var suggestionLabel = UILabel()
    
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
        configureSuggestionLabel(text: model.noSuggestion)
        
        view.addSubview(suggestionLabel)
        view.addSubview(cityTextField)
        view.addSubview(confirmButton)
        
        constraintSuggestionLabel()
        constraintTextField()
        constraintConfirmButton()
    }
    
    func configureNavigationController(with title: String) {
        self.title = title
    }
    
    func configureSuggestionLabel(text: String){
        suggestionLabel.text = text
        suggestionLabel.font = UIFont.boldSystemFont(ofSize: 24)
        suggestionLabel.textColor = .accentColor
        suggestionLabel.textAlignment = .center
        suggestionLabel.numberOfLines = 0
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    func constraintSuggestionLabel() {
        let constraints = [
            suggestionLabel.bottomAnchor.constraint(equalTo: cityTextField.topAnchor, constant: -25),
            suggestionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            suggestionLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -40)
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
    
    func constraintTextField() {
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            cityTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cityTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            cityTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -40)
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
