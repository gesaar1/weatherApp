//
//  DeviceLocationService.swift
//  App01
//
//  Created by Getter Saar on 03.01.2024.
//

import Foundation
import Combine
import CoreLocation

class LocationService : NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?

    var locationUpdateHandler: ((String) -> Void)?
    
    override init() {
        super.init()
        setupLocationManager()
        requestLocation()
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestInitialLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func requestLocation() {
       // locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            displayLocation(location)
            reverseGeocodeLocation(location)
            stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }

    func displayLocation(_ location: CLLocation) {
        // Handle displaying or processing location information here
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        print("Latitude: \(String(describing: currentLatitude)), Longitude: \(String(describing: currentLongitude))")
          
    }
    
    func reverseGeocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let locationName = "\(placemark.name ?? "") \(placemark.locality ?? "") \(placemark.administrativeArea ?? "")"
                self.locationUpdateHandler?(locationName)
                print(locationName)
                
            }
        }
        
    }
    
    
}
