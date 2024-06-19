import UIKit

final class CurrentWeatherTableViewCell: UITableViewCell, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = CurrentWeatherCellModel
    
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    
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
    }
}

//MARK: Appearance
private extension CurrentWeatherTableViewCell {
    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .getAppColor(.secondaryBackgroundColor)
        
        configureCityLabelAppearance()
        configureTemperatureLabelAppearance()
        
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        
        constraintTemperatureLabel()
        constraintCityLabel()
    }
    
    func configureCityLabelAppearance() {
        cityLabel.font = FontLibrary.title
        cityLabel.textColor = .getAppColor(.accentColor)
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 1
    }
    
    func configureTemperatureLabelAppearance() {
        temperatureLabel.font = FontLibrary.title
        temperatureLabel.textColor = .getAppColor(.accentColor)
        temperatureLabel.textAlignment = .center
        temperatureLabel.numberOfLines = 1
    }
    
    func constraintCityLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false

        let insets = 10.0
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
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
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets),
        ])
    }
}
