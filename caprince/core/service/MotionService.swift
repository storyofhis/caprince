//
//  MotionService.swift
//  caprince
//
//  Created by Bernardus William Santosa on 03/05/26.
//

import Foundation
import CoreMotion

class MotionService {
    private let activityManager = CMMotionActivityManager()
    var onActivityUpdate: ((String) -> Void)?
    
    func startTracking() {
        guard CMMotionActivityManager.isActivityAvailable() else { return }
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }
            if activity.running { self?.onActivityUpdate?("Running Mode") }
            else if activity.walking { self?.onActivityUpdate?("Walk Mode") }
            else { self?.onActivityUpdate?("Stationary Mode") }
        }
    }
    
    func stopTracking() {
        activityManager.stopActivityUpdates()
    }
}

