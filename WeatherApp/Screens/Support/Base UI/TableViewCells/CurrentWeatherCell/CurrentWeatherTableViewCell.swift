import UIKit
import SnapKit

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
        if model.city.split(separator: " ").count > 1 {
            cityLabel.numberOfLines = 3
        } else {
            cityLabel.numberOfLines = 1
        }

        cityLabel.text = model.city
        temperatureLabel.text = model.temperatureText
        conditionLabel.text = model.condition
        cityLabel.sizeToFit()
    }
}

// MARK: Appearance
private extension CurrentWeatherTableViewCell {
    func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .getAppColor(.secondaryBackgroundColor)

        configureCityLabelAppearance()
        configureTemperatureLabelAppearance()
        configureConditionLabelAppearance()

        addSubviews()

        constraintTemperatureLabel()
        constraintCityLabel()
        constraintConditionLabel()
    }

    func addSubviews() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionLabel)
    }

    func configureCityLabelAppearance() {
        cityLabel.font = FontLibrary.title
        cityLabel.textColor = .getAppColor(.accentColor)
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 0
        cityLabel.minimumScaleFactor = 0.5
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
        let insets = 25.0

        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(insets)
            make.trailing.equalToSuperview().offset(-insets)
            make.leading.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(insets)
        }
    }

    func constraintTemperatureLabel() {
        let insets = 25.0

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(insets)
            make.leading.equalToSuperview().inset(insets)
            make.trailing.equalTo(contentView.snp.centerX).offset(-insets)
        }
    }

    func constraintConditionLabel() {
        let insets = 25.0
        let interItemOffset = 10.0

        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(interItemOffset)
            make.leading.equalToSuperview().offset(insets)
            make.bottom.equalToSuperview().inset(insets)
            make.trailing.equalTo(contentView.snp.centerX).offset(-insets)
        }
    }
}
