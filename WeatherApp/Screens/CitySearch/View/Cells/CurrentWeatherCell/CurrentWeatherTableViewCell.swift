import UIKit

final class CurrentWeatherTableViewCell: UITableViewCell, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = CurrentWeatherCellModel
    
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with model: CurrentWeatherCellModel) {
        cityLabel.text = model.city
        temperatureLabel.text = model.temperatureText
        conditionLabel.text = model.condition
    }
}

//MARK: Appearance
private extension CurrentWeatherTableViewCell {
    func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .getAppColor(.secondaryBackgroundColor)
        
        configureCityLabelAppearance()
        configureTemperatureLabelAppearance()
        configureConditionLabelAppearance()
        
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionLabel)
        
        constraintTemperatureLabel()
        constraintCityLabel()
        constraintConditionLabel()
    }
    
    func configureCityLabelAppearance() {
        cityLabel.font = FontLibrary.title
        cityLabel.textColor = .getAppColor(.accentColor)
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 1
        cityLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureTemperatureLabelAppearance() {
        temperatureLabel.font = FontLibrary.title
        temperatureLabel.textColor = .getAppColor(.accentColor)
        temperatureLabel.textAlignment = .center
        temperatureLabel.numberOfLines = 1
    }
    
    func configureConditionLabelAppearance() {
        conditionLabel.font = FontLibrary.body
        conditionLabel.textColor = .getAppColor(.accentOp)
        conditionLabel.textAlignment = .center
        conditionLabel.numberOfLines = 1
        conditionLabel.adjustsFontSizeToFitWidth = true
    }
    
    func constraintCityLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false

        let insets = 25.0
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
            cityLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5, constant: -insets),
            cityLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: insets),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets),
        ])
    }
    
    func constraintTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        let insets = 25.0
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            temperatureLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5, constant: -insets),
        ])
    }
    
    func constraintConditionLabel() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false

        let insets = 25.0
        let interItemInset = 10.0
        
        NSLayoutConstraint.activate([
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: interItemInset),
            conditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            conditionLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5, constant: -insets),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets),
            conditionLabel.trailingAnchor.constraint(equalTo: cityLabel.leadingAnchor, constant: -insets),
        ])
    }
}
