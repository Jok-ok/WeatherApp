import UIKit

class CityViewController: UIViewController, CityViewInput {
    
    private var cityTextField = StandartTextField()
    private var confirmButton = StandartButton()
    private var suggestionLabel = UILabel()
    private var citiesCollectionView: CitiesCollectionViewAdapter?
    
    var output: CityViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
    }
    
    // MARK: - CityViewInput
    func setupInitialState(model: CityPresenterModel) {
        configureApperance(with: model)
        setupCitiesCollectionView()
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

//MARK: - CitiesCollectionView
private extension CityViewController {
    func setupCitiesCollectionView() {
        let layout = setupCollectioViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        citiesCollectionView = CitiesCollectionViewAdapter(output: self, collectionView: collectionView)
        
        let constraints = [
            collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            collectionView.bottomAnchor.constraint(equalTo: suggestionLabel.topAnchor, constant: -25),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCollectioViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func constraintCitiesCollectionView() {
        
    }
}

extension CityViewController: CitiesCollectionViewAdapterOutput {
    func didSelectCityView(with text: String) {
        cityTextField.text = text
    }
}

// MARK: - Actions
private extension CityViewController {
    @objc func confirmCity() {
        output?.confirmButtonPressed(with: cityTextField.text ?? "")
    }
    
    @objc func cityTextFieldEdited() {
        let cities = output?.cityTextFieldEdited(with: cityTextField.text ?? "") ?? []
        citiesCollectionView?.configure(with: cities)
    }
}
