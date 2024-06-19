import UIKit

extension UITableView {
    func dequeueReusableCell<CellType: UITableViewCell>(with cellType: CellType.Type, for indexPath: IndexPath ) -> CellType where CellType: CellIdentifiableProtocol {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? CellType else { return CellType() }

        return cell
    }
    
    func dequeueReusableHeaderFooter<CellType: UITableViewHeaderFooterView>(with cellType: CellType.Type) -> CellType where CellType: CellIdentifiableProtocol {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: cellType.reuseIdentifier) as? CellType else { return CellType() }

        return cell
    }
}
