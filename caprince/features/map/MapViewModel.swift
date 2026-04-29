//
//  MapViewModel.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI
import MapKit
import Combine
import SwiftData

enum RunState {
    case idle
    case running
    case paused
}

final class MapViewModel: ObservableObject {
    
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var route: [CLLocationCoordinate2D] = []
    @Published var runState: RunState = .idle
    
    private let locationService = LocationService()
    private var cancellables = Set<AnyCancellable>()
    private var hasSetInitialPosition = false
    
    @Published var elapsedTime: TimeInterval = 0

    private var timer: AnyCancellable?
    private var lastUpdateDate: Date?
    
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
        lastUpdateDate = Date()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let now = Date()
                if self.runState == .running, let last = self.lastUpdateDate {
                    self.elapsedTime += now.timeIntervalSince(last)
                }
                self.lastUpdateDate = now
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func bindLocation() {
        locationService.$locations
            .sink { [weak self] locations in
                guard let self = self, self.runState == .running else { return }
                
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
        guard runState == .idle else { return }
        
        route.removeAll()
        runState = .running
        elapsedTime = 0
        
        locationService.start()
        startTimer()
    }
    
    func pauseTracking() {
        guard runState == .running else { return }
        runState = .paused
    }
    
    func resumeTracking() {
        guard runState == .paused else { return }
        lastUpdateDate = Date() // Reset update date so we don't jump time
        runState = .running
    }

    func finishTracking(context: ModelContext) {
        guard runState != .idle else { return }
        
        let session = RunSession(
            duration: elapsedTime,
            distance: totalDistance() / 1000.0,
            averagePace: averagePace()
        )
        
        do {
            context.insert(session)
            try context.save()
            print("✅ Run saved successfully")
        } catch {
            print("❌ Error saving run: \(error.localizedDescription)")
        }
        
        // Reset state
        runState = .idle
        locationService.stop()
        stopTimer()
        route.removeAll()
        elapsedTime = 0
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
    
    func averagePace() -> String {
        let distanceKm = totalDistance() / 1000.0
        guard distanceKm > 0.01 else { return "0'00\"" } // Prevent weird numbers if distance is tiny
        
        let totalMinutes = elapsedTime / 60.0
        let paceMinutes = totalMinutes / distanceKm
        
        guard paceMinutes < 60 else { return "59'59\"" } // Cap pace if extremely slow
        
        let min = Int(paceMinutes)
        let sec = Int((paceMinutes - Double(min)) * 60.0)
        
        return String(format: "%d'%02d\"", min, sec)
    }
}
