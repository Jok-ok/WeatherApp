import UIKit

class TableViewSection<Cell: UITableViewCell & CellConfigurableProtocol & CellIdentifiableProtocol>: TableViewSectionProtocol{
    typealias CellModel = Cell.Model
    typealias Cell = Cell
    typealias CellModelHandler = (CellModel) -> Void
    
    private let tapHandler: CellModelHandler?
    private let removeItemHandler: CellModelHandler?
    
    private var header: TableViewSectionHeaderFooterProtocol?
    private var footer: TableViewSectionHeaderFooterProtocol?
    
    var isEditable: Bool
    
    var items: [CellModel]
    
    var count: Int {
        items.count
    }
    
    init(items: [CellModel] = [],
         isEditable: Bool = false,
         tapHandler: CellModelHandler? = nil,
         removeItemHandler: CellModelHandler? = nil) {
        self.isEditable = isEditable
        self.tapHandler = tapHandler
        self.removeItemHandler = removeItemHandler
        self.items = items
    }
    
    func onItemSelected(at: Int) {
        tapHandler?(items[at])
    }
    
    func removeItem(at row: Int) {
        let removedItem = items.remove(at: row)
        removeItemHandler?(removedItem)
    }
    
    func dequeueReusableCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: Cell.self, for: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func setHeaderCell(with cell: TableViewSectionHeaderFooterProtocol) {
        header = cell
    }
    
    func setFooterCell(with cell: TableViewSectionHeaderFooterProtocol) {
        footer = cell
    }
    
    func dequeueReusableHeader(_ tableView: UITableView) -> UIView? {
        header?.dequeReusableHeaderFooter(tableView)
    }
    
    func dequeueReusableFooter(_ tableView: UITableView) -> UIView? {
        footer?.dequeReusableHeaderFooter(tableView)
    }
    
    var heightForFooter: CGFloat {
        if let footer {
            return footer.height
        } else {
            return .leastNormalMagnitude
        }
    }
    var heightForHeader: CGFloat {
        if let header {
            return header.height
        } else {
            return .leastNormalMagnitude
        }
    }
}
