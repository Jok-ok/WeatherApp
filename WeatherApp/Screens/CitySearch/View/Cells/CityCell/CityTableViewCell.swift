import UIKit

final class CityTableViewCell: UITableViewCell, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = CityCellModel
    private let cityNameLabel = UILabel()
    private let subtitleLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CityCellModel) {
        cityNameLabel.text = model.cityName
        subtitleLable.text = model.subtitle
    }
}

//MARK: - Appearance
private extension CityTableViewCell {
    func configureAppearance() {
        backgroundColor = .getAppColor(.secondaryBackgroundColor)
        configureCityNameLabelAppearance()
        configureSubtitileLabelAppearance()
        
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
    
    func constraintCityNameLabel() {
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cityNameLabel)
        let insets = 10.0
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            cityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
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
            subtitleLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
            subtitleLable.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: labelInset),
            subtitleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets),
        ])
    }
}
