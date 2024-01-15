import UIKit

final class CityCollectionViewCell: UICollectionViewCell, CityCollectionViewCellProtocol {
    private let cityLabel = UILabel()
    
    func configure(with text: String) {
        cityLabel.text = text
    }
}

// MARK: - Appearance
private extension CityCollectionViewCell {
    
}
