//
//  UserStats.swift
//  caprince
//
//  A single persistent record tracking the user's cumulative lifetime stats.
//  There should only ever be ONE instance of this in the database.
//

import Foundation
import SwiftData
import WidgetKit

@Model
final class UserStats {

    // MARK: - Core Run Totals
    // Incremented each time a RunSession is saved in FinishRunView
    var totalSessionsCompleted: Int
    var totalDistanceKm: Double
    var totalCaloriesBurned: Double
    var totalDurationSeconds: TimeInterval

    // MARK: - Program Progress
    // Incremented each time a TrainingDay is marked as Done
    var totalDaysCompleted: Int
    var totalWeeksCompleted: Int

    /// A pre-computed 0.0–1.0 value representing overall program completion.
    /// (e.g. 4 days done out of 18 total = 0.22)
    /// Update this whenever totalDaysCompleted changes.
    /// Feed this directly into the Capybara storyline progress bar!
    var programProgress: Double

    // MARK: - Timestamps
    var appFirstLaunchDate: Date
    var lastSessionDate: Date?     // nil until the first run is completed

    // MARK: - Computed Helpers (not stored — calculated on the fly)
    /// Average pace across all runs, in minutes per km.
    /// Returns nil if no runs have been completed yet.
    var averagePaceMinPerKm: Double? {
        guard totalDistanceKm > 0 else { return nil }
        return (totalDurationSeconds / 60.0) / totalDistanceKm
    }

    /// Average pace formatted as "MM:SS /km" for display in the UI.
    /// Returns "--:--" if no runs have been completed yet.
    var formattedAveragePace: String {
        guard let pace = averagePaceMinPerKm, pace < 60 else { return "--:--" }
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Total program days available. Update this if the plan ever changes.
    static let totalProgramDays: Int = 18 // 6 weeks × 3 days

    // MARK: - Init

    init(
        totalSessionsCompleted: Int = 0,
        totalDistanceKm: Double = 0,
        totalCaloriesBurned: Double = 0,
        totalDurationSeconds: TimeInterval = 0,
        totalDaysCompleted: Int = 0,
        totalWeeksCompleted: Int = 0,
        programProgress: Double = 0,
        appFirstLaunchDate: Date = Date(),
        lastSessionDate: Date? = nil
    ) {
        self.totalSessionsCompleted = totalSessionsCompleted
        self.totalDistanceKm = totalDistanceKm
        self.totalCaloriesBurned = totalCaloriesBurned
        self.totalDurationSeconds = totalDurationSeconds
        self.totalDaysCompleted = totalDaysCompleted
        self.totalWeeksCompleted = totalWeeksCompleted
        self.programProgress = programProgress
        self.appFirstLaunchDate = appFirstLaunchDate
        self.lastSessionDate = lastSessionDate
    }

    // MARK: - Mutating Helpers
    // Call these after a run is saved or a day is marked done.

    /// Call this in FinishRunView after inserting a new RunSession.
    func recordRun(distanceKm: Double, calories: Double, durationSeconds: TimeInterval) {
        totalSessionsCompleted += 1
        totalDistanceKm += distanceKm
        totalCaloriesBurned += calories
        totalDurationSeconds += durationSeconds
        lastSessionDate = Date()
    }

    /// Call this whenever a TrainingDay is marked as isCompleted = true.
    /// Pass in the full list of all weeks so the function can recalculate accurately.
    func recordDayCompleted(allWeeks: [TrainingWeek]) {
        let completedDays = allWeeks.flatMap { $0.days }.filter { $0.isCompleted }.count
        let completedWeeks = allWeeks.filter { $0.days.allSatisfy { $0.isCompleted } }.count

        totalDaysCompleted = completedDays
        totalWeeksCompleted = completedWeeks
        programProgress = Double(completedDays) / Double(UserStats.totalProgramDays)
        
        // Sync progress to Widget via App Group
        var perWeekArray = [Int]()
        for week in allWeeks {
            perWeekArray.append(week.days.filter { $0.isCompleted }.count)
        }
        // Ensure it has exactly 6 items as expected by the widget
        while perWeekArray.count < 6 { perWeekArray.append(0) }
        
        let progress = StorylineProgress(perWeekCompleted: Array(perWeekArray.prefix(6)))
        if let data = try? JSONEncoder().encode(progress),
           let defaults = UserDefaults(suiteName: "group.com.appleacademy.caprince.share") {
            defaults.set(data, forKey: "storyline.progress")
            WidgetCenter.shared.reloadTimelines(ofKind: "caprinceWidget")
        }
    }

}

// Shared model to serialize data for the Widget
struct StorylineProgress: Codable, Equatable {
    var perWeekCompleted: [Int]
}
