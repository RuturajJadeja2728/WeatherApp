//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import CoreLocation

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var getUpdatedLocation: ((CLLocationCoordinate2D?) -> Void)?
    
    private override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate Methods

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted.")
            startUpdatingLocation()
        case .denied, .restricted:
            print("Location permission denied.")
            DispatchQueueMain.async { [weak self] in
                self?.getUpdatedLocation?(nil)
            }
            stopUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Updated location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            
            getUpdatedLocation?(location.coordinate)
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
        getUpdatedLocation?(nil)
    }
}
