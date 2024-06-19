import Foundation

protocol LocationServiceProtocol {
    func startUpdatingLocation()
    func stopUpdationgLocation()
    func getLocation() -> Location?
}
