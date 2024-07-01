import UIKit.UITableView

class TableViewHeaderFooter<HeaderFooterCell: UITableViewHeaderFooterView &
                                CellIdentifiableProtocol &
                                CellConfigurableProtocol>:
                                    TableViewSectionHeaderFooterProtocol {
    typealias HeaderFooterModel = HeaderFooterCell.Model

    private let cellModel: HeaderFooterModel

    init(cellModel: HeaderFooterModel) {
        self.cellModel = cellModel
    }

    func dequeReusableHeaderFooter(_ tableView: UITableView) -> UIView {
        let cell = tableView.dequeueReusableHeaderFooter(with: HeaderFooterCell.self)
        cell.configure(with: cellModel)
        return cell
    }

    var height: CGFloat {
        return UITableView.automaticDimension
    }
}
