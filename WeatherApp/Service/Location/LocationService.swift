import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationServiceDelegate?
    fileprivate let locationManager = CLLocationManager()
    var location: Location?

    override init() {
        super.init()

        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            self.location = Location(latitude: location.coordinate.latitude,
                                     longitude: location.coordinate.longitude)
            delegate?.didUpdateLocation()
        }
    }
}

extension LocationService: LocationServiceProtocol {
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopUpdationgLocation() {
        locationManager.stopUpdatingLocation()
    }

    func getLocation() -> Location? {
        return location
    }
}
