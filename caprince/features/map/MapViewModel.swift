import Foundation
import _MapKit_SwiftUI
import MapKit
import Combine

enum RunState {
    case idle, running, paused, finished
}

class RunTrackerViewModel: ObservableObject {
    @Published var sessionState: RunState = .idle
    @Published var isMaximized: Bool = false
    @Published var currentActivity: String = "Stationary Mode"
    
    // Tracking Data
    @Published var distance: Double = 0.0
    @Published var timeElapsed: Int = 0
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    private var timer: Timer?
    private let motionService = MotionService()
    private let locationService = LocationService()
    
    init() {
        locationService.onLocationUpdate = { [weak self] coords in self?.coordinates = coords }
        locationService.onDistanceUpdate = { [weak self] dist in self?.distance = dist }
        motionService.onActivityUpdate = { [weak self] act in self?.currentActivity = act }
    }
    
    // MARK: - Actions
    func startSession() {
        sessionState = .running
        cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
        locationService.startTracking()
        motionService.startTracking()
        startTimer()
    }
    
    func pauseSession() {
        sessionState = .paused
        locationService.pauseTracking()
        stopTimer()
    }
    
    func resumeSession() {
        sessionState = .running
        cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
        locationService.startTracking()
        startTimer()
    }
    
    func resetSession() {
        sessionState = .idle
        isMaximized = false
        stopTimer()
        locationService.pauseTracking()
        motionService.stopTracking()
        locationService.resetData()
        timeElapsed = 0
        currentActivity = "Stationary Mode"
    }
    func stopSession() {
        sessionState = .finished
        stopTimer()
    }
    
    // MARK: - Formatters & Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timeElapsed += 1
        }
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var formattedTime: String {
        let h = timeElapsed/3600
        let m = (timeElapsed % 3600) / 60
        let s = timeElapsed % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    var formattedPace: String {
        guard distance > 0.01 else { return "-:--" }
        let totalMinutes = Double(timeElapsed) / 60
        let pace = totalMinutes / distance
        guard pace < 60 else { return "59:59" } //Cap pace
        let m = Int(pace)
        let s = Int((pace - Double(m)) * 60)
        return String(format: "%d:%02d", m, s)
    }
}
