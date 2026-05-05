//
//  ContentView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            NavigationStack {
                mainPageView()
            }
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TrainingWeek.self, configurations: config)
    
    for week in RunningPlan.beginnerPlans {
        container.mainContext.insert(week)
    }

    return ContentView()
        .modelContainer(container)
}
