import SwiftUI
import SwiftData

struct ActiveWeekCardView: View {
    @Bindable var week: TrainingWeek
    @Binding var popupState: WorkoutPopupState?
    
    @State private var expandedDayId: UUID? = nil
    @State private var navigateToMap = false
    @State private var selectedDay: TrainingDay? = nil
    
    @Environment(\.modelContext) private var context
    @Query var allWeeks: [TrainingWeek]
    @Query var userStatsQuery: [UserStats]
    var stats: UserStats? { userStatsQuery.first }
    
    var sortedDays: [TrainingDay] {
        week.days.sorted { $0.title < $1.title }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(sortedDays.enumerated()), id: \.element.id) { index, day in
                let isExpanded = expandedDayId == day.id
                
                HStack(alignment: .top, spacing: 16) {
                    // Timeline and Circle
                    VStack(spacing: 0) {
                        // Circle
                        ZStack {
                            Circle()
                                .fill(isExpanded ? Color("Brown-600") : Color.gray.opacity(0.2))
                                .frame(width: 56, height: 56)
                            
                            if day.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.title2.bold())
                                    .foregroundStyle(isExpanded ? .white : Color("Brown-600"))
                            } else {
                                Text("\(index + 1)")
                                    .font(.title2.bold())
                                    .foregroundStyle(isExpanded ? .white : .white)
                            }
                        }
                        .shadow(color: isExpanded ? Color("Brown-600").opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
                        
                        // Bottom line
                        if index < sortedDays.count - 1 {
                            Rectangle()
                                .fill(Color("Brown-300").opacity(0.5))
                                .frame(width: 3) // Flexible height to perfectly connect to the next circle
                        }
                    }
                    .frame(width: 60)
                    
                    // Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Workout \(index + 1)")
                            .font(.headline)
                            .foregroundStyle(isExpanded ? Color("Brown-600") : .gray)
                        
                        if isExpanded {
                            HStack(spacing: 12) {
                                ForEach(extractTags(from: day.duration), id: \.text) { tag in
                                    Text(tag.text)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(Color.black.opacity(0.8))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .stroke(tag.color, lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(isExpanded ? Color(red: 1, green: 0.98, blue: 0.88) : Color.gray.opacity(0.15))
                    .cornerRadius(12)
                    .shadow(color: isExpanded ? Color.black.opacity(0.1) : .clear, radius: 5, x: 0, y: 3)
                    .padding(.bottom, 24) // Adds vertical space between cards, stretching the HStack so the Rectangle bridges the gap
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            if expandedDayId == day.id {
                                // If already expanded, open the popup
                                let isAvailable = (day.id == sortedDays.first(where: { !$0.isCompleted })?.id)
                                popupState = WorkoutPopupState(
                                    weekTitle: week.title,
                                    day: day,
                                    isAvailable: isAvailable,
                                    onStart: {
                                        withAnimation { popupState = nil }
                                        selectedDay = day
                                        navigateToMap = true
                                    },
                                    onMarkDone: {
                                        markDayDone(day: day)
                                    }
                                )
                            } else {
                                expandedDayId = day.id
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            if expandedDayId == nil {
                if let firstUncompleted = sortedDays.first(where: { !$0.isCompleted }) {
                    expandedDayId = firstUncompleted.id
                } else {
                    expandedDayId = sortedDays.first?.id
                }
            }
        }
        .navigationDestination(isPresented: $navigateToMap) {
            MainMapView(week: week, day: selectedDay, onRunComplete: {
                if let day = selectedDay {
                    markDayDone(day: day)
                }
                navigateToMap = false
            })
        }
    }
    
    private func markDayDone(day: TrainingDay) {
        if let index = week.days.firstIndex(where: { $0.id == day.id }) {
            week.days[index].isCompleted = true
            try? week.modelContext?.save()
            stats?.recordDayCompleted(allWeeks: allWeeks)
            try? context.save()
        }
        withAnimation { popupState = nil }
    }
    
    // Tag Extraction Helper
    struct WorkoutTag: Hashable {
        let text: String
        let color: Color
    }
    
    private func extractTags(from duration: String) -> [WorkoutTag] {
        var result: [WorkoutTag] = []
        let components = duration.components(separatedBy: CharacterSet(charactersIn: "&+"))
        
        for comp in components {
            var str = comp.trimmingCharacters(in: .whitespaces)
            
            if let range = str.range(of: "Repeat [0-9]+x", options: [.regularExpression, .caseInsensitive]) {
                let repeatPart = String(str[range])
                str.removeSubrange(range)
                str = str.trimmingCharacters(in: .whitespaces)
                
                if !str.isEmpty {
                    result.append(contentsOf: getTag(for: str))
                }
                let repText = repeatPart.replacingOccurrences(of: "Repeat", with: "Rep.", options: .caseInsensitive)
                result.append(WorkoutTag(text: repText, color: Color.red.opacity(0.8)))
            } else {
                if !str.isEmpty {
                    result.append(contentsOf: getTag(for: str))
                }
            }
        }
        
        if result.isEmpty {
            result.append(WorkoutTag(text: duration, color: Color("Brown-500")))
        }
        
        return result
    }
    
    private func getTag(for string: String) -> [WorkoutTag] {
        let lower = string.lowercased()
        if lower.contains("run") {
            return [WorkoutTag(text: string, color: Color("Brown-500"))]
        } else if lower.contains("walk") {
            return [WorkoutTag(text: string, color: Color("green-200"))]
        }
        return [WorkoutTag(text: string, color: .gray)]
    }
}
