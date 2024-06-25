import UIKit.UITableView

protocol TableViewSectionHeaderFooterProtocol {
    var height: CGFloat { get }
    func dequeReusableHeaderFooter(_ tableView: UITableView) -> UIView
}
