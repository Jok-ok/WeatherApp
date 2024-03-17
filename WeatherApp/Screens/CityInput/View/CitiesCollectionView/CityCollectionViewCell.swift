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
        provinceLabel.text = subtitle
    }
    
    func onTouchDownAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func onTouchUpAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
            self.transform = CGAffineTransform.identity
        }
    }
    
}

// MARK: - Appearance
private extension CityCollectionViewCell {
    func configureAppearance() {
        configureLocalityLabel()
        configureProvinceLabel()
        
        contentView.addSubview(localityLabel)
        contentView.addSubview(provinceLabel)
        
        constraintLocalityLabel()
        constraintProvinceLabel()
    }
    
    
    func configureLocalityLabel() {
        localityLabel.textColor = .accentColor
        localityLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        localityLabel.numberOfLines = 3
        localityLabel.lineBreakMode = .byClipping
        localityLabel.textAlignment = .left
        localityLabel.adjustsFontSizeToFitWidth = true
        localityLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureProvinceLabel() {
        provinceLabel.textColor = .accentOp
        provinceLabel.backgroundColor = .backgroundColor
        provinceLabel.layer.cornerRadius = 10
        provinceLabel.layer.masksToBounds = true
        provinceLabel.font = .boldSystemFont(ofSize: 14)
        provinceLabel.numberOfLines = 10
        provinceLabel.lineBreakMode = .byWordWrapping
        provinceLabel.textAlignment = .left
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
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
