import UIKit

final class CityCollectionViewCell: UICollectionViewCell, CityCollectionViewCellProtocol {
    private let cityLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with text: String) {
        cityLabel.text = text
    }
}

// MARK: - Appearance
private extension CityCollectionViewCell {
    func configureAppearance() {
        backgroundColor = .accentColor
        self.layer.cornerRadius = 10
        
        configureCityLabel()
        
        self.contentView.addSubview(cityLabel)
        
        constraintCityLabel()
    }
    
    func configureCityLabel() {
        cityLabel.font = .boldSystemFont(ofSize: 24)
        cityLabel.textColor = .buttonFontColor
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintCityLabel() {
        let constraints = [
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
