//
//  RunSession.swift
//  caprince
//
//

import Foundation
import SwiftData

@Model
final class RunSession {
    var id: UUID
    var date: Date
    var programName: String
    var timeElapsed: TimeInterval
    var distance: Double
    var averagePace: String
    var steps: Int
    var calories: Double
    var routeData: Data?
    
    init(id: UUID = UUID(), date: Date = Date(), programName: String, timeElapsed: TimeInterval, distance: Double, averagePace: String, steps: Int, calories: Double, routeData: Data? = nil) {
        self.id = id
        self.date = date
        self.programName = programName
        self.timeElapsed = timeElapsed
        self.distance = distance
        self.averagePace = averagePace
        self.steps = steps
        self.calories = calories
        self.routeData = routeData
    }
}

