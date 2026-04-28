//
//  RunSession.swift
//  caprince
//
//  Created by Antigravity on 24/04/26.
//

import Foundation
import SwiftData

@Model
final class RunSession {
    var id: UUID
    var date: Date
    var duration: TimeInterval
    var distance: Double
    var averagePace: String
    
    init(id: UUID = UUID(), date: Date = Date(), duration: TimeInterval, distance: Double, averagePace: String) {
        self.id = id
        self.date = date
        self.duration = duration
        self.distance = distance
        self.averagePace = averagePace
    }
}
