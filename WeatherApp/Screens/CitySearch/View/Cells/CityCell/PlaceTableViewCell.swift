import UIKit
import SnapKit

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
        let starImage = UIImage(systemName: isFavorite ? "star.fill" : "star")

        guard let accentColor = UIColor.getAppColor(.accentColor) else { return }
        favoriteButton.setImage(starImage?.withTintColor(accentColor), for: .normal)
    }
}

// MARK: - Appearance
private extension PlaceTableViewCell {
    func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .getAppColor(.secondaryBackgroundColor)
        configureCityNameLabelAppearance()
        configureSubtitileLabelAppearance()
        configureFavoriteButtonAppearance()
        addSubviews()

        constraintFavoriteButton()
        constraintCityNameLabel()
        constraintSubtitleLabel()
    }

    func addSubviews() {
        contentView.addSubview(favoriteButton)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(subtitleLable)
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
        let insets = 10.0
        cityNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(insets)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-insets)
            make.top.equalToSuperview().offset(insets)
        }
    }

    func constraintSubtitleLabel() {
        let insets = 10.0
        let labelInset = 5.0

        subtitleLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(insets)
            make.trailing.lessThanOrEqualTo(favoriteButton.snp.leading).offset(-insets)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(labelInset)
            make.bottom.equalToSuperview().offset(-insets)
        }
    }

    func constraintFavoriteButton() {
        let insets = 10.0
        favoriteButton.snp.contentCompressionResistanceHorizontalPriority = 1000

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-insets)
            make.top.greaterThanOrEqualToSuperview().offset(insets)
            make.bottom.lessThanOrEqualToSuperview().offset(-insets)
            make.centerY.equalToSuperview()
        }
    }
}
