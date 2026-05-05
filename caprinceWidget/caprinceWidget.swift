//
//  caprinceWidget.swift
//  caprinceWidget
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import WidgetKit
import SwiftUI

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

fileprivate let kStorylineUserDefaultsSuite = "group.com.appleacademy.caprince.share"

fileprivate let kStorylineKey = "storyline.progress"

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), progress: .default())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let progress = loadProgress()
        return SimpleEntry(date: Date(), configuration: configuration, progress: progress)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        // Read current progress from shared UserDefaults (App Group). If not available, use default sample.
        let progress = loadProgress()
        
        // Create a single timeline entry and rely on WidgetCenter.reload... when app updates the model.
        let entry = SimpleEntry(date: Date(), configuration: configuration, progress: progress)
        return Timeline(entries: [entry], policy: .never)
    }
    
    fileprivate func loadProgress() -> StorylineProgress {
        if let defaults = UserDefaults(suiteName: kStorylineUserDefaultsSuite),
           let data = defaults.data(forKey: kStorylineKey),
           let model = try? JSONDecoder().decode(StorylineProgress.self, from: data) {
            // validate length
            if model.perWeekCompleted.count == 6 { return model }
            // if data exists but is invalid length, normalize it
            var normalized = model.perWeekCompleted
            if normalized.count < 6 { normalized.append(contentsOf: Array(repeating: 0, count: 6 - normalized.count)) }
            if normalized.count > 6 { normalized = Array(normalized.prefix(6)) }
            return StorylineProgress(perWeekCompleted: normalized)
        }
        return .default()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let progress: StorylineProgress
}

struct caprinceWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Capyrun!")
                        .font(.headline)
                    Text("Week \(entry.progress.currentWeekIndex + 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                // Castle at right as goal
                Image("castle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .offset(y:35)
            }
            
            // Main bar with mascot moving along
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let barHeight: CGFloat = 14
                let leftPadding: CGFloat = 8
                let rightPadding: CGFloat = 8
                let usableWidth = totalWidth - leftPadding - rightPadding - 28 // leave space for castle emoji
                
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: barHeight)
                    
                    // Filled portion based on completed workouts this week
                    let completed = entry.progress.perWeekCompleted[entry.progress.currentWeekIndex]
                    let ratio = Double(completed) / 3.0
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: max(12, usableWidth * ratio), height: barHeight)
                    
                    
                    // Mascot (emoji) positioned on the filled portion end (or start if none)
                    let mascotX = leftPadding + CGFloat(ratio) * usableWidth - 12
                    HStack(spacing: 0) {
                        Image("actorWidget")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .offset(x: max(leftPadding - 6, mascotX), y:-20)
                        Spacer()
                    }
                }
            }
            .frame(height: 44)
            
            // Numbers 1 2 3 under the bar, spaced evenly
            HStack {
                ForEach(1...3, id: \.self) { step in
                    Spacer()
                    Text("\(step)")
                        .font(.system(size: 12))
                        .foregroundColor(.brown)
                    Spacer()
                }
            }
        }
        .widgetURL(URL(string: "caprince://storyline?week=\(entry.progress.currentWeekIndex + 1)"))
    }
}

struct caprinceWidget: Widget {
    let kind: String = "caprinceWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            caprinceWidgetEntryView(entry: entry)
                // Gunakan modifier ini untuk background full container
                .containerBackground(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.88), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.64, green: 0.74, blue: 0.55), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0.71),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ),
                    for: .widget
                )
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
}

#Preview(as: .systemSmall) {
    caprinceWidget()
} timeline: {
    // Provide two example timeline entries for preview: one empty and one partially completed
    let empty = StorylineProgress.default()
    var partial = StorylineProgress(perWeekCompleted: [3,1,0,0,0,0])
    SimpleEntry(date: .now, configuration: .smiley, progress: empty)
    SimpleEntry(date: .now, configuration: .smiley, progress: partial)
}
