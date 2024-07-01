import Foundation

protocol LocationServiceProtocol {
    var delegate: LocationServiceDelegate? { get set }
    func startUpdatingLocation()
    func stopUpdationgLocation()
    func getLocation() -> Location?
}
