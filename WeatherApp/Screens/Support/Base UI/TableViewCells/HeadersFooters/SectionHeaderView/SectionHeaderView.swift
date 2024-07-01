import UIKit
import SnapKit

final class SectionHeaderView: UITableViewHeaderFooterView, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = SectionHeaderModel

    private let headerTextLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: SectionHeaderModel) {
        headerTextLabel.text = model.headerText
    }

}
// MARK: Appearance
private extension SectionHeaderView {
    func configureAppearance() {
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(headerTextLabel)
        configureLabelAppearance()
        constraintLabel()
    }

    func configureLabelAppearance() {
        headerTextLabel.font = FontLibrary.headline
        headerTextLabel.textColor = .getAppColor(.accentColor)
        headerTextLabel.textAlignment = .left
        headerTextLabel.numberOfLines = 0
    }

    func constraintLabel() {
        let insets = 10.0

        headerTextLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(insets).priority(.low)
        }
    }
}
