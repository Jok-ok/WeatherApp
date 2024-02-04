import UIKit

final class CityCollectionViewCell: UICollectionViewCell, CityCollectionViewCellProtocol {
    private let localityLabel = UILabel()
    private var localityLabelBottomConstraint: NSLayoutConstraint?
    private let provinceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, subtitle: String?=nil) {
        localityLabel.text = text
        if subtitle != nil {
            localityLabelBottomConstraint?.isActive = false
            provinceLabel.text = subtitle
            provinceLabel.isHidden = false
        } else {
            localityLabelBottomConstraint?.isActive = true
            provinceLabel.isHidden = true
        }
        contentView.layoutIfNeeded()
    }
    
}

// MARK: - Appearance
private extension CityCollectionViewCell {
    func configureAppearance() {
        contentView.backgroundColor = .accentColor
        contentView.layer.cornerRadius = 10
        configureLocalityLabel()
        configureProvinceLabel()
        
        contentView.addSubview(localityLabel)
        contentView.addSubview(provinceLabel)
        
        constraintLocalityLabel()
        constraintProvinceLabel()
    }
    
    
    func configureLocalityLabel() {
        localityLabel.textColor = .buttonFontColor
        localityLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        localityLabel.numberOfLines = 3
        localityLabel.lineBreakMode = .byClipping
        localityLabel.textAlignment = .center
        localityLabel.adjustsFontSizeToFitWidth = true
        localityLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureProvinceLabel() {
        provinceLabel.textColor = .accentColor
        provinceLabel.backgroundColor = .backgroundColor
        provinceLabel.layer.cornerRadius = 10
        provinceLabel.layer.masksToBounds = true
        provinceLabel.font = .boldSystemFont(ofSize: 14)
        provinceLabel.numberOfLines = 10
        provinceLabel.lineBreakMode = .byWordWrapping
        provinceLabel.textAlignment = .center
        provinceLabel.adjustsFontSizeToFitWidth = true
        provinceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintLocalityLabel() {
        let constraints = [
            localityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            localityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            localityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ]
        
        localityLabelBottomConstraint = localityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func constraintProvinceLabel() {
        let constraints = [
            provinceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            provinceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            provinceLabel.topAnchor.constraint(equalTo: localityLabel.bottomAnchor, constant: 5),
            provinceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            provinceLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45 )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
