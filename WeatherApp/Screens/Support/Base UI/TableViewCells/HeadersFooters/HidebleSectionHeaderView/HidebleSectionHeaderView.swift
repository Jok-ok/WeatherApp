import UIKit

final class HidebleSectionHeaderView: UITableViewHeaderFooterView, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = HidebleSectionHeaderModel

    private let headerTextLabel = UILabel()
    private let eyeButton = UIButton()
    private var model: Model?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Model) {
        headerTextLabel.text = model.headerText
        self.model = model
    }

}
// MARK: Appearance
private extension HidebleSectionHeaderView {
    func configureAppearance() {
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        configureLabelAppearance()
        configureEyeButtonAppearance()

        constraintEyeButton()
        constraintLabel()
    }

    func configureLabelAppearance() {
        headerTextLabel.font = FontLibrary.headline
        headerTextLabel.textColor = .getAppColor(.accentColor)
        headerTextLabel.textAlignment = .left
        headerTextLabel.numberOfLines = 0
    }

    func configureEyeButtonAppearance() {
        let eyeImage = UIImage(systemName: "eye")
        eyeButton.setImage(eyeImage, for: .normal)
        eyeButton.addAction(UIAction { [weak self] _ in
            self?.model?.onEyeTappedAction()
        }, for: .touchUpInside)
    }

    func constraintLabel() {
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerTextLabel)
        let insets = 10.0

        NSLayoutConstraint.activate([
            headerTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: eyeButton.leadingAnchor, constant: -insets),
            headerTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            headerTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
            headerTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets)
        ])
    }

    func constraintEyeButton() {
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eyeButton)
        let insets = 10.0
        eyeButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            eyeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
            eyeButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: insets),
            eyeButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -insets),
            eyeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
