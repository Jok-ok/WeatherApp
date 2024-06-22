import UIKit

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
//MARK: Appearance
private extension SectionHeaderView {
    func configureAppearance() {
        contentView.autoresizingMask = [.flexibleHeight,  .flexibleWidth]
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
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerTextLabel)
        let insets = 10.0
        
        NSLayoutConstraint.activate([
            headerTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            headerTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            headerTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
            headerTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets),
        ])
    }
}
