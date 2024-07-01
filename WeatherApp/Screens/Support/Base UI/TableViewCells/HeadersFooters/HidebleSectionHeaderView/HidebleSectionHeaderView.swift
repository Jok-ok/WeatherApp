import UIKit
import SnapKit

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
        addSubviews()

        constraintEyeButton()
        constraintLabel()
    }

    func addSubviews() {
        contentView.addSubview(eyeButton)
        contentView.addSubview(headerTextLabel)
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
        let insets = 10.0

        headerTextLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(insets)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(eyeButton.snp.leading).inset(insets)
        }
    }

    func constraintEyeButton() {
        let insets = 10.0
        eyeButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        eyeButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(insets)
            make.trailing.equalToSuperview().inset(insets)
            make.centerY.equalToSuperview()
        }
    }
}
