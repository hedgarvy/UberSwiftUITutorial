//
//  LocationManager.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 26/05/26.
//

import CoreLocation

@Observable
class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
}
 
extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }
    
}
