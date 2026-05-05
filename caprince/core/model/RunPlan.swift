//
//  RunPlan.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 30/04/26.
//

import Foundation
import SwiftData

@Model // writes database code
final class TrainingDay: Identifiable {
    // final class -> trck a single a single instance of a workout to save it
    var id: UUID
    var title: String
    var duration: String
    var isCompleted: Bool
    
    // Swift data class requires an initializer (structs generate an invis init, but class does not)
    init(id: UUID = UUID(), title: String, duration: String, isCompleted: Bool = false) {
        self.id = id // membedakan funcs and variables (of the same name)
        self.title = title
        self.duration = duration
        self.isCompleted = isCompleted
    }
}

@Model
final class TrainingWeek: Identifiable {
    var id: UUID
    var title: String
    // deleting a week = deleting days
    @Relationship(deleteRule: .cascade) var days: [TrainingDay]
    
    init(id: UUID = UUID(), title: String, days: [TrainingDay]) {
        self.id = id
        self.title = title
        self.days = days
    }
}
