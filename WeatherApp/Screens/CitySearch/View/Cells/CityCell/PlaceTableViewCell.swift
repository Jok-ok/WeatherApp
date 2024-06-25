import UIKit

final class PlaceTableViewCell: UITableViewCell, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = PlaceCellModel
    private let cityNameLabel = UILabel()
    private let subtitleLable = UILabel()
    private let favoriteButton = UIButton()
    private var model: PlaceCellModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: PlaceCellModel) {
        cityNameLabel.text = model.cityName
        subtitleLable.text = model.subtitle
        setCellFavorite(isFavorite: model.isFavorite)
        
        self.model = model
    }
    
    private func favoriteButtonDidTaped() {
        guard let model else { return }
        model.onFavoriteButtonTappedAction?(model)
    }
    
    private func setCellFavorite(isFavorite: Bool) {
        var starImage = UIImage(systemName: isFavorite ? "star.fill" : "star")

        guard let accentColor = UIColor.getAppColor(.accentColor) else { return }
        favoriteButton.setImage(starImage?.withTintColor(accentColor), for: .normal)
    }
}

//MARK: - Appearance
private extension PlaceTableViewCell {
    func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .getAppColor(.secondaryBackgroundColor)
        configureCityNameLabelAppearance()
        configureSubtitileLabelAppearance()
        configureFavoriteButtonAppearance()
        
        constraintFavoriteButton()
        constraintCityNameLabel()
        constraintSubtitleLabel()
    }
    
    func configureCityNameLabelAppearance() {
        cityNameLabel.font = FontLibrary.body
        cityNameLabel.textColor = .getAppColor(.accentColor)
        cityNameLabel.textAlignment = .left
        cityNameLabel.numberOfLines = 0
    }
    
    func configureSubtitileLabelAppearance() {
        subtitleLable.font = FontLibrary.caption
        subtitleLable.textColor = .getAppColor(.accentOp)
        subtitleLable.textAlignment = .left
        subtitleLable.numberOfLines = 0
    }
    
    func configureFavoriteButtonAppearance() {
        setCellFavorite(isFavorite: false)
        
        let action = UIAction { [weak self] _ in
            self?.model?.isFavorite.toggle()
            self?.favoriteButtonDidTaped()
            self?.setCellFavorite(isFavorite: self?.model?.isFavorite ?? false)
        }
        
        favoriteButton.addAction(action, for: .touchUpInside)
    }
    
    func constraintCityNameLabel() {
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cityNameLabel)
        let insets = 10.0
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            cityNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor, constant: -insets),
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
        ])
    }
    
    func constraintSubtitleLabel() {
        subtitleLable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLable)
        let insets = 10.0
        let labelInset = 5.0
        
        NSLayoutConstraint.activate([
            subtitleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            subtitleLable.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor, constant: -insets),
            subtitleLable.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: labelInset),
            subtitleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets),
        ])
    }
    
    func constraintFavoriteButton() {
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        
        let insets = 10.0
        favoriteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
            favoriteButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: insets),
            favoriteButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -insets),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
