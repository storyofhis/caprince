//
//  LocationService.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//
import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: (([CLLocationCoordinate2D]) -> Void)?
    var onDistanceUpdate: ((Double) -> Void)?
    
    private var coordinates: [CLLocationCoordinate2D] = []
    private var totalDistance: Double = 0.0 // Dalam KM
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading() //cone
    }
    
    func pauseTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    func resetData() {
        coordinates.removeAll()
        totalDistance = 0.0
        onLocationUpdate?(coordinates)
        onDistanceUpdate?(totalDistance)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        coordinates.append(location.coordinate)
        onLocationUpdate?(coordinates)
        
        if coordinates.count > 1 {
            let previous = CLLocation(latitude: coordinates[coordinates.count - 2].latitude,
                                      longitude: coordinates[coordinates.count - 2].longitude)
            totalDistance += (location.distance(from: previous) / 1000.0)
            onDistanceUpdate?(totalDistance)
        }
    }
}
