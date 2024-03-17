import Foundation
import CoreLocation

class LocationService {
    private let locationManager = CLLocationManager()
    
    func getLocation() {
        locationManager.requestLocation()
        locationManager.location?.coordinate.latitude
    }
}
