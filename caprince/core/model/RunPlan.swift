//
//  RunPlan.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 30/04/26.
//

import Foundation
import SwiftData

enum ActivityType: String, Codable {
    case run = "Run"
    case walk = "Walk"
}

struct WorkoutStep: Codable, Identifiable {
    var id: UUID = UUID()
    var activity: ActivityType
    var durationInSeconds: Int
}

struct WorkoutHelper {
    static func interval(run: Int, walk: Int, repeats: Int) -> [WorkoutStep] {
        var steps: [WorkoutStep] = []
        for _ in 0..<repeats {
            steps.append(WorkoutStep(activity: .run, durationInSeconds: run * 60))
            if walk > 0 {
                steps.append(WorkoutStep(activity: .walk, durationInSeconds: walk * 60))
            }
        }
        return steps
    }
}

@Model // writes database code
final class TrainingDay: Identifiable {
    // final class -> trck a single a single instance of a workout to save it
    var id: UUID
    var title: String
    var duration: String
    var steps: [WorkoutStep]
    var isCompleted: Bool
    
    // Swift data class requires an initializer (structs generate an invis init, but class does not)
    init(id: UUID = UUID(), title: String, duration: String, steps: [WorkoutStep] = [], isCompleted: Bool = false) {
        self.id = id // membedakan funcs and variables (of the same name)
        self.title = title
        self.duration = duration
        self.steps = steps
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
                TrainingDay(title: "Day 1", duration: "Run 1 min & walk 1 min Repeat 10x", steps: WorkoutHelper.interval(run: 1, walk: 1, repeats: 10)),
                TrainingDay(title: "Day 2", duration: "Run 2 min & walk 4 min Repeat 5x", steps: WorkoutHelper.interval(run: 2, walk: 4, repeats: 5)),
                TrainingDay(title: "Day 3", duration: "Run 2 min & walk 4 min Repeat 5x", steps: WorkoutHelper.interval(run: 2, walk: 4, repeats: 5))
            ]
        ),
        TrainingWeek(
            title: "Week 2",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 3 min & walk 3 min Repeat 4x", steps: WorkoutHelper.interval(run: 3, walk: 3, repeats: 4)),
                TrainingDay(title: "Day 2", duration: "Run 3 min & walk 3 min Repeat 4x", steps: WorkoutHelper.interval(run: 3, walk: 3, repeats: 4)),
                TrainingDay(title: "Day 3", duration: "Run 5 min & walk 3 min Repeat 3x", steps: WorkoutHelper.interval(run: 5, walk: 3, repeats: 3))
            ]
        ),
        TrainingWeek(
            title: "Week 3",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 7 min & walk 2 min Repeat 3x", steps: WorkoutHelper.interval(run: 7, walk: 2, repeats: 3)),
                TrainingDay(title: "Day 2", duration: "Run 8 min & walk 2 min Repeat 3x", steps: WorkoutHelper.interval(run: 8, walk: 2, repeats: 3)),
                TrainingDay(title: "Day 3", duration: "Run 8 min & walk 2 min Repeat 3x", steps: WorkoutHelper.interval(run: 8, walk: 2, repeats: 3))
            ]
        ),
        TrainingWeek(
            title: "Week 4",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 8 min & walk 2 min Repeat 3x", steps: WorkoutHelper.interval(run: 8, walk: 2, repeats: 3)),
                TrainingDay(title: "Day 2", duration: "Run 10 min & walk 2 min Repeat 2x + Run 5 min", steps: WorkoutHelper.interval(run: 10, walk: 2, repeats: 2) + WorkoutHelper.interval(run: 5, walk: 0, repeats: 1)),
                TrainingDay(title: "Day 3", duration: "Run 8 min & walk 2 min Repeat 1x", steps: WorkoutHelper.interval(run: 8, walk: 2, repeats: 1))
            ]
        ),
        TrainingWeek(
            title: "Week 5",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 9 min & walk 1 min Repeat 4x", steps: WorkoutHelper.interval(run: 9, walk: 1, repeats: 4)),
                TrainingDay(title: "Day 2", duration: "Run 12 min & walk 2 min Repeat 2x + Run 5 min", steps: WorkoutHelper.interval(run: 12, walk: 2, repeats: 2) + WorkoutHelper.interval(run: 5, walk: 0, repeats: 1)),
                TrainingDay(title: "Day 3", duration: "Run 8 min & walk 2 min Repeat 3x", steps: WorkoutHelper.interval(run: 8, walk: 2, repeats: 3))
            ]
        ),
        TrainingWeek(
            title: "Week 6",
            days: [
                TrainingDay(title: "Day 1", duration: "Run 15 min & walk 1 min Repeat 2x", steps: WorkoutHelper.interval(run: 15, walk: 1, repeats: 2)),
                TrainingDay(title: "Day 2", duration: "Run 8 min & walk 2 min Repeat 3x", steps: WorkoutHelper.interval(run: 8, walk: 2, repeats: 3)),
                TrainingDay(title: "Day 3", duration: "Race Day!", steps: WorkoutHelper.interval(run: 30, walk: 0, repeats: 1)) // Assuming a 30 min run for race day
            ]
        )
    ]
}
