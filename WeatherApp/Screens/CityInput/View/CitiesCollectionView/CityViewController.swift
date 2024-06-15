import UIKit

class CityViewController: UIViewController, CityViewInput {
    // MARK: - Private properties
    private lazy var currentLocationLabel = UILabel()
    private lazy var currentTempLabel = UILabel()
    private var citiesCollectionViewAdapter: CitiesCollectionViewAdapter?
    private var citiesCollectionView: UICollectionView?
    private lazy var suggestionLabel = UILabel()
    private lazy var cityTextField = StandartTextField()
    private lazy var confirmButton = StandartButton()
    private lazy var collectionViewGradient = CAGradientLayer()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewGradient()
    }
    
    // MARK: - CityViewInput
    func setupInitialState(model: CityPresenterModel) {
        setupCitiesCollectionView()
        configureApperance(with: model)
    }
    
    func configureCollectionViewData(with titles: [String], subtitles: [String?]) {
        animateSuggestion()
        hideCollectionViewWithAnimation()
        citiesCollectionViewAdapter?.configure(with: titles, subtitles: subtitles)
        showeCollectionViewWithAnimation()
    }
    
}

// MARK: - Appearance
private extension CityViewController {
    
    // MARK: - UIConfiguration
    func configureApperance(with model: CityPresenterModel) {
        configureNavigationController(with: model.title)
        self.view.backgroundColor = .backgroundColor
        suggestionSecondText = model.suggestionLabelText
        
        guard let citiesCollectionView = citiesCollectionView else { return }
        
        configureCurrentWeatherLabel(with: model.currentLocation)
        configureCurrentTempLabel(currentWeather: model.temperaturePlaceholder)
        configureTextField(with: model.cityEntryPlaceholder)
        configureConfirmButton(with: model.confirmButtonTitle)
        configureSuggestionLabel(with: model.noSuggestion)
        configureGradient()
        
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
        currentLocationLabel.font = UIFont.boldSystemFont(ofSize: 18)
        currentLocationLabel.textColor = .accentColor
        currentLocationLabel.textAlignment = .center
        currentLocationLabel.numberOfLines = 0
        currentLocationLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCurrentTempLabel(currentWeather: String) {
        currentTempLabel.text = currentWeather
        currentTempLabel.font = .boldSystemFont(ofSize: 24)
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
        suggestionLabel.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    func configureGradient() {
        guard let citiesCollectionView else { return }
        collectionViewGradient.frame = citiesCollectionView.bounds
        collectionViewGradient.delegate = self
        collectionViewGradient.colors = [
            UIColor(white: 1, alpha: 0).cgColor,
            UIColor(white: 1, alpha: 1).cgColor,
            UIColor(white: 1, alpha: 1).cgColor,
            UIColor(white: 1, alpha: 0).cgColor
        ]
        collectionViewGradient.locations = [0, 0.05, 0.9, 1]
        citiesCollectionView.layer.mask = collectionViewGradient
    }
    
    // MARK: - Constraints
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
        
        let heightConstraint = citiesCollectionView.heightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.heightAnchor,
            multiplier: 0.18)
        heightConstraint.priority = .fittingSizeLevel
        collectionViewHeightConstraint = heightConstraint
        
        let constraints = [
            //            heightConstraint,
            citiesCollectionView.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 25),
            citiesCollectionView.bottomAnchor.constraint(equalTo: suggestionLabel.topAnchor, constant: -25),
            citiesCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            citiesCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40),
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
            confirmButton.leadingAnchor.constraint(equalTo: cityTextField.trailingAnchor, constant: 5),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
            confirmButton.heightAnchor.constraint(equalTo: cityTextField.heightAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintTextField() {
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            cityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cityTextField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
            cityTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.65)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    // MARK: - Animations
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.opacity = 0
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        citiesCollectionView = collectionView
        
        citiesCollectionViewAdapter = CitiesCollectionViewAdapter(output: self, collectionView: collectionView)
    }
    
    func setupCollectioViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(75))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item,])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 20,
                                      bottom: 0, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func updateCollectionViewGradient() {
        guard let citiesCollectionView else {return}
        collectionViewGradient.frame = CGRect(
            x: 0,
            y: citiesCollectionView.contentOffset.y,
            width: citiesCollectionView.bounds.width,
            height: citiesCollectionView.bounds.height)
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
    func didSelectCityView(with title: String, subtitle: String?) {
        cityTextField.text = title
        if let subtitle {
            cityTextField.text? += ", \(subtitle)"
        }
    }
    func collectionViewDidScroll() {
        updateCollectionViewGradient()
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

// MARK: - CALayerDelegate
extension CityViewController: CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}
