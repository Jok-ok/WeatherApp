import UIKit

protocol TableViewSectionProtocol {
    var count: Int { get }
    var isEditable: Bool { get }
    func onItemSelected(at row: Int)
    func removeItem(at row: Int)
    func dequeueReusableCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func dequeueReusableHeader(_ tableView: UITableView) -> UIView?
    func dequeueReusableFooter(_ tableView: UITableView) -> UIView?
    var heightForFooter: CGFloat { get }
    var heightForHeader: CGFloat { get }
}
