import UIKit

class CityViewController: UIViewController, CityViewInput {
    private var currentLocationLabel = UILabel()
    private var currentTempLabel = UILabel()
    private var citiesCollectionViewAdapter: CitiesCollectionViewAdapter?
    private var citiesCollectionView: UICollectionView?
    private var suggestionLabel = UILabel()
    private var cityTextField = StandartTextField()
    private var confirmButton = StandartButton()
    
    private var suggestionSecondText: String?
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var suggestionLabelBottomConstraint: NSLayoutConstraint?
    
    var output: CityViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
    }
    
    // MARK: - CityViewInput
    func setupInitialState(model: CityPresenterModel) {
        setupCitiesCollectionView()
        configureApperance(with: model)
    }
    
    func configureCollectionViewData(with suggests: [Suggest]) {
        animateSuggestion()
        hideCollectionViewWithAnimation()
        citiesCollectionViewAdapter?.configure(with: suggests)
        showeCollectionViewWithAnimation()
    }
    
}

// MARK: - Appearance
private extension CityViewController {
    func configureApperance(with model: CityPresenterModel) {
        configureNavigationController(with: model.title)
        self.view.backgroundColor = .white
        suggestionSecondText = model.suggestionLabelText
        
        guard let citiesCollectionView = citiesCollectionView else { return }
        
        configureCurrentWeatherLabel(with: model.currentLocation)
        configureCurrentTempLabel(currentWeather: model.temperaturePlaceholder)
        configureTextField(with: model.cityEntryPlaceholder)
        configureConfirmButton(with: model.confirmButtonTitle)
        configureSuggestionLabel(with: model.noSuggestion)
        
        view.addSubview(currentLocationLabel)
        view.addSubview(currentTempLabel)
        view.addSubview(citiesCollectionView)
        view.addSubview(suggestionLabel)
        view.addSubview(cityTextField)
        view.addSubview(confirmButton)
        
        constraintCurrentWeatherLabel()
        constraintCurrentTempLabel()
        constraintCitiesCollectionView()
        constraintSuggestionLabel()
        constraintTextField()
        constraintConfirmButton()
    }
    
    func configureCurrentWeatherLabel(with text: String) {
        currentLocationLabel.text = text
        currentLocationLabel.font = UIFont.boldSystemFont(ofSize: 24)
        currentLocationLabel.textColor = .accentColor
        currentLocationLabel.textAlignment = .center
        currentLocationLabel.numberOfLines = 0
        currentLocationLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCurrentTempLabel(currentWeather: String) {
        currentTempLabel.text = currentWeather
        currentTempLabel.font = .boldSystemFont(ofSize: 36)
        currentTempLabel.textColor = .accentColor
        currentTempLabel.textAlignment = .center
        currentTempLabel.numberOfLines = 0
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureNavigationController(with title: String) {
        self.title = title
    }
    
    func configureSuggestionLabel(with text: String){
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
    
    func constraintCurrentWeatherLabel() {
        let constraints = [
            currentLocationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            currentLocationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintCurrentTempLabel() {
        let constraints = [
            currentTempLabel.topAnchor.constraint(equalTo: currentLocationLabel.bottomAnchor),
            currentTempLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintCitiesCollectionView() {
        guard let citiesCollectionView = citiesCollectionView else { return }
        
        let heightConstraint = citiesCollectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        collectionViewHeightConstraint = heightConstraint
        
        let constraints = [
            heightConstraint,
            citiesCollectionView.bottomAnchor.constraint(equalTo: suggestionLabel.topAnchor, constant: -25),
            citiesCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            citiesCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintSuggestionLabel() {
        let bottomConstraint = suggestionLabel.bottomAnchor.constraint(equalTo: cityTextField.topAnchor, constant: -25)
        
        let constraints = [
            bottomConstraint,
            suggestionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            suggestionLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -40)
        ]
        
        suggestionLabelBottomConstraint = bottomConstraint
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintConfirmButton() {
        let constraints = [
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
            confirmButton.heightAnchor.constraint(equalTo: cityTextField.heightAnchor),
            confirmButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.19)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintTextField() {
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            cityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cityTextField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
            cityTextField.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -15),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func animateSuggestion() {
        if suggestionLabel.text == suggestionSecondText {
            return
        }
        
        self.suggestionLabelBottomConstraint?.constant = -25 + suggestionLabel.frame.height
        UIView.animate(withDuration: 0.6, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5, animations: { [weak self] in
            guard let self = self else { return }
            self.suggestionLabel.layer.opacity = 0
            
            self.view.layoutIfNeeded()
        } )
        {   [weak self] val in
            guard let self = self else { return }
            self.suggestionLabel.text = suggestionSecondText
            self.suggestionLabelBottomConstraint?.constant = -25
            UIView.animate(withDuration: 0.6, delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 5, animations: { [weak self] in
                guard let self = self else { return }
                self.suggestionLabel.layer.opacity = 1
                self.view.layoutIfNeeded()
            } )
        }
    }
}

//MARK: - CitiesCollectionView
private extension CityViewController {
    func setupCitiesCollectionView() {
        let layout = setupCollectioViewLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.layer.opacity = 0
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        citiesCollectionView = collectionView
        
        citiesCollectionViewAdapter = CitiesCollectionViewAdapter(output: self, collectionView: collectionView)
    }
    
    func setupCollectioViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(300),
            heightDimension: .absolute(100))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(300),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 20,
                                      bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func hideCollectionViewWithAnimation() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.citiesCollectionView?.layer.opacity = 0
        })
    }
    
    func showeCollectionViewWithAnimation() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.citiesCollectionView?.layer.opacity = 1
        }
    }
}

// MARK: - CollectionView output
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
        output?.cityTextFieldEdited(with: cityTextField.text ?? "")
    }
}
