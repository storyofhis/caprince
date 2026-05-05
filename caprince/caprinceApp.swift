import SwiftUI
import SwiftData

@main
struct caprinceApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            // Notice how we put BOTH TrainingWeek and RunSession here!
            container = try ModelContainer(for: TrainingWeek.self, RunSession.self, UserStats.self)
            
            // 🛑 CHECK: Is the database empty?
            let descriptor = FetchDescriptor<TrainingWeek>()
            let existingWeeks = try container.mainContext.fetch(descriptor)
            
            if existingWeeks.isEmpty {
                // 🟢 SEED: If empty, loop through your beginnerPlans and save them!
                for week in RunningPlan.beginnerPlans {
                    container.mainContext.insert(week)
                }
            }
            
            // 🛑 CHECK: Create a UserStats singleton if none exists
            let statsDescriptor = FetchDescriptor<UserStats>()
            let existingStats = try container.mainContext.fetch(statsDescriptor)
            if existingStats.isEmpty {
                container.mainContext.insert(UserStats())
            }
        } catch {
            fatalError("Failed to initialize SwiftData container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
