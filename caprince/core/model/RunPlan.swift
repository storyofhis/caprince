//
//  RunPlan.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 30/04/26.
//

import Foundation
import SwiftData

struct TrainingDay: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    var isCompleted: Bool = false
}

struct TrainingWeek: Identifiable {
    let id = UUID()
    let title: String
    var days: [TrainingDay]
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

