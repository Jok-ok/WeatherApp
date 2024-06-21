protocol CellIdentifiableProtocol {
    static var reuseIdentifier: String { get }
}

extension CellIdentifiableProtocol {
    static var reuseIdentifier: String { String(describing: self) }
}
