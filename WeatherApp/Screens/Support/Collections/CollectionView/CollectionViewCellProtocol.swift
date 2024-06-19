import UIKit.UICollectionViewCell

protocol CollectionViewCellProtocol: AnyObject, CellIdentifiableProtocol where Self: UICollectionViewCell {
    associatedtype DataType
    
    func configure(with: DataType)
}
