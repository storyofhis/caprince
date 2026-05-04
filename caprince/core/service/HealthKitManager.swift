//
//  HealthKitManager.swift
//  caprince
//
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    @Published var stepCount: Double = 0
    @Published var caloriesBurned: Double = 0
    @Published var isAuthorized: Bool = false
    
    // Request permission to read steps and calories
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        
        let typesToRead: Set = [stepType, calorieType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.fetchTodaySteps()
                    self?.fetchTodayCalories()
                } else if let error = error {
                    print("HealthKit Authorization Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Fetch total steps for the current day
    func fetchTodaySteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error fetching steps: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.stepCount = sum.doubleValue(for: HKUnit.count())
            }
        }
        
        healthStore.execute(query)
    }
    
    // Fetch total active energy burned for the current day
    func fetchTodayCalories() {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error fetching calories: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.caloriesBurned = sum.doubleValue(for: HKUnit.kilocalorie())
            }
        }
        
        healthStore.execute(query)
    }
}
