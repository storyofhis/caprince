//
//  MainPageViewModel.swift
//  caprince
//
//  Created by Antigravity on \(Date())
//

import Foundation
import Combine

class MainPageViewModel: ObservableObject {
    @Published var stepsText: String = "0"
    @Published var caloriesText: String = "0"
    
    private var cancellables = Set<AnyCancellable>()
    private var healthKitManager = HealthKitManager.shared
    
    init() {
        // Observe step count changes
        healthKitManager.$stepCount
            .receive(on: RunLoop.main)
            .map { String(format: "%.0f", $0) }
            .assign(to: \.stepsText, on: self)
            .store(in: &cancellables)
            
        // Observe calories burned changes
        healthKitManager.$caloriesBurned
            .receive(on: RunLoop.main)
            .map { String(format: "%.0f", $0) }
            .assign(to: \.caloriesText, on: self)
            .store(in: &cancellables)
    }
    
    func requestHealthData() {
        healthKitManager.requestAuthorization()
    }
}
