//
//  caprinceWidget.swift
//  caprinceWidget
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import WidgetKit
import SwiftUI

<<<<<<< Updated upstream
=======
// Simple model to represent storyline progress: 6 weeks × 3 workouts per week.
struct StorylineProgress: Codable, Equatable {
    // perWeekCompleted[i] is number of workouts completed in week i (0..3)
    var perWeekCompleted: [Int] // expected length 6
    
    static func `default`() -> StorylineProgress {
        StorylineProgress(perWeekCompleted: [0,0,0,0,0,0])
    }
    
    var totalCompleted: Int { perWeekCompleted.reduce(0, +) }
    var totalWorkouts: Int { perWeekCompleted.count * 3 }
    
    // current week (1-based): first week that is not fully complete, or last week
    var currentWeekIndex: Int {
        for (i, v) in perWeekCompleted.enumerated() {
            if v < 3 { return i }
        }
        return max(0, perWeekCompleted.count - 1)
    }
}

// Key and App Group placeholder. Replace the group id with your real App Group identifier.
fileprivate let kStorylineUserDefaultsSuite = "com.appleacademy.caprince${DEVELOPMENT_TEAM}"
fileprivate let kStorylineKey = "storyline.progress"

>>>>>>> Stashed changes
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct caprinceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct caprinceWidget: Widget {
    let kind: String = "caprinceWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            caprinceWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    caprinceWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
