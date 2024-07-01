import Foundation

protocol CellConfigurableProtocol {
    associatedtype Model

    func configure(with model: Model)
}
