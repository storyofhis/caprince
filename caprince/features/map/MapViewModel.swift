//
//  MapViewModel.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI
import MapKit
import Combine

final class MapViewModel: ObservableObject {
    
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var route: [CLLocationCoordinate2D] = []
    @Published var isTracking = false
    
    private let locationService = LocationService()
    private var cancellables = Set<AnyCancellable>()
    private var hasSetInitialPosition = false
    
    @Published var elapsedTime: TimeInterval = 0

    private var timer: AnyCancellable?
    private var startTime: Date?
    private var endTime: Date?
    
    init() {
        bindLocation()
//        locationService.requestLocation()
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let start = self.startTime else { return }
                self.elapsedTime = Date().timeIntervalSince(start)
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func bindLocation() {
        locationService.$locations
            .sink { [weak self] locations in
                guard let self = self, self.isTracking else { return }
                
                guard let last = locations.last,
                      last.horizontalAccuracy < 20 else { return }
                
                let coordinate = last.coordinate
                
                // ✅ Append new point
                self.route.append(coordinate)
                
                // ✅ Move camera
                self.updateCamera(coordinate)
                
                // ✅ Save for widget
                self.saveToSharedStorage(coordinate)
            }
            .store(in: &cancellables)
    }
    
    private func updateCamera(_ coordinate: CLLocationCoordinate2D) {
        let camera = MKMapCamera(
            lookingAtCenter: coordinate,
            fromDistance: 1000,
            pitch: 60,
            heading: 220
        )
        
        cameraPosition = .camera(MapCamera(camera))
    }
    
    private func saveToSharedStorage(_ coordinate: CLLocationCoordinate2D) {
        let defaults = UserDefaults(suiteName: "group.com.appleacademy.caprince")
        defaults?.set(coordinate.latitude, forKey: "lat")
        defaults?.set(coordinate.longitude, forKey: "lon")
    }
    
    func startTracking() {
        guard !isTracking else { return }
        
        route.removeAll()
        isTracking = true
        elapsedTime = 0
        startTime = Date()
        
        locationService.start()   // ✅ NOT requestLocation()
        startTimer()
    }

    func stopTracking() {
        guard isTracking else { return }
        
        isTracking = false
        endTime = Date()
        
        locationService.stop()    // ✅ IMPORTANT
        stopTimer()
    }
    
    func recenter() {
        if let coordinate = locationService.locations.last?.coordinate {
            updateCamera(coordinate)
        }
    }
    
    func totalDistance() -> Double {
        guard route.count > 1 else { return 0 }
        
        return zip(route, route.dropFirst()).reduce(0) { result, pair in
            let start = CLLocation(latitude: pair.0.latitude, longitude: pair.0.longitude)
            let end = CLLocation(latitude: pair.1.latitude, longitude: pair.1.longitude)
            return result + start.distance(from: end)
        }
    }
}
