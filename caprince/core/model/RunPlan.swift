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

enum RunningPlan {
    static let beginnerPlans: [TrainingWeek] = [
        TrainingWeek(
            title: "Week 1",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 1 min & walk 1 min Repeat 10x"),
                TrainingDay(title: "Day 2", duration: "Run 2 min & walk 4 min Repeat 5x"),
                TrainingDay(title: "Day 3", duration: "Run 2 min & walk 4 min Repeat 5x")
            ]
        ),
        TrainingWeek(
            title: "Week 2",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 3 min & walk 3 min Repeat 4x"),
                TrainingDay(title: "Day 2", duration: "Run 3 min & walk 3 min Repeat 4x"),
                TrainingDay(title: "Day 3", duration: "Run 5 min & walk 3 min Repeat 3x")
            ]
        ),
        TrainingWeek(
            title: "Week 3",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 7 min & walk 2 min Repeat 3x"),
                TrainingDay(title: "Day 2", duration: "Run 8 min & walk 2 min Repeat 3x"),
                TrainingDay(title: "Day 3", duration: "Run 8 min & walk 2 min Repeat 3x")
            ]
        ),
        TrainingWeek(
            title: "Week 4",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 8 min & walk 2 min Repeat 3x"),
                TrainingDay(title: "Day 2", duration: "Run 10 min & walk 2 min Repeat 2x + Run 5 min"),
                TrainingDay(title: "Day 3", duration: "Run 8 min & walk 2 min Repeat 1x")
            ]
        ),
        TrainingWeek(
            title: "Week 5",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 9 min & walk 1 min Repeat 4x"),
                TrainingDay(title: "Day 2", duration: "Run 12 min & walk 2 min Repeat 2x + Run 5 min"),
                TrainingDay(title: "Day 3", duration: "Run 8 min & walk 2 min Repeat 3x")
            ]
        ),
        TrainingWeek(
            title: "Week 6",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 15 min & walk 1 min Repeat 2x"),
                TrainingDay(title: "Day 2", duration: "Run 8 min & walk 2 min Repeat 3x"),
                TrainingDay(title: "Day 3", duration: "Race Day!")
            ]
        )
    ]
}
