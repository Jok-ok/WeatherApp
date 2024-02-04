import Foundation
import CoreLocation

class LocationManager {
    private let locationManager = CLLocationManager()
    
    func getLocation() {
        locationManager.requestLocation()
        locationManager.location?.coordinate.latitude
    }
}
