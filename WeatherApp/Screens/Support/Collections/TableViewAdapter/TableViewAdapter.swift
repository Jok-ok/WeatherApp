import UIKit

class TableViewAdapter: NSObject {
    private weak var tableView: UITableView?
    private var sections: [TableViewSectionProtocol] = []
    private var hidedSectionIndexes = Set<Int>()
    
    init(tableView: UITableView){
        self.tableView = tableView
        super.init()
        
        setupTable()
    }
    
    func hideSection(with index: Int) {
        hidedSectionIndexes.insert(index)
    }
    
    func showSection(with index: Int) {
        hidedSectionIndexes.remove(index)
    }
    
    func register<CellType: UITableViewCell>(cellType: CellType.Type) where CellType: CellIdentifiableProtocol {
        tableView?.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func register<CellType: UITableViewHeaderFooterView>(headerFooterType: CellType.Type) where CellType: CellIdentifiableProtocol {
        tableView?.register(headerFooterType, forHeaderFooterViewReuseIdentifier: headerFooterType.reuseIdentifier)
    }
    
    private func setupTable() {
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func configure(with sections: [TableViewSectionProtocol]) {
        self.sections = sections
    }
    
    func append(section: TableViewSectionProtocol) {
        self.sections.append(section)
    }
    
    func reloadTableView() {
        tableView?.reloadData()
    }
    
    func reloadSection(_ section: Int, with animation: UITableView.RowAnimation = .automatic ) {
        tableView?.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    func insertRow(at section: Int, row: Int) {
        if !hidedSectionIndexes.contains(section) {
            tableView?.insertRows(at: [IndexPath(row: row, section: section)], with: .automatic) }
    }
    
    func removeRow(at section: Int, row: Int) {
        if !hidedSectionIndexes.contains(section) {
            tableView?.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic) }
    }
    
    func reloadRow(at section: Int, row: Int) {
        if !hidedSectionIndexes.contains(section) {
            tableView?.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic) }
    }
}

extension TableViewAdapter: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hidedSectionIndexes.contains(section) { return 0 }
        else { return sections[section].count }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        sections[indexPath.section].isEditable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sections[indexPath.section].removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].dequeueReusableCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].dequeueReusableHeader(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sections[section].dequeueReusableFooter(tableView)
    }
}

extension TableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].onItemSelected(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sections[section].heightForFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].heightForHeader
    }
}

