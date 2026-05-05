//
//  WeekCardView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 29/04/26.
//

import SwiftUI
import SwiftData

struct WeekCardView: View {

    @State private var navigateToMap = false
    @State private var selectedDay: TrainingDay? = nil
    @Bindable var week: TrainingWeek
    @Binding var popupState: WorkoutPopupState?
    var isLocked: Bool = false
    
    // Needed to update UserStats after marking a day done
    @Environment(\.modelContext) private var context
    @Query var allWeeks: [TrainingWeek]
    @Query var userStatsQuery: [UserStats]
    var stats: UserStats? { userStatsQuery.first }
    
    var progress: CGFloat {
        let completed = week.days.filter { $0.isCompleted }.count
        return CGFloat(completed) / CGFloat(week.days.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(week.title)
                .font(.headline)
            // TODO: Change this color into default asset
                .foregroundStyle(.white)
                .padding(.horizontal, 26)
                .padding(.vertical, 10)
                .background(Color(red: 0.45, green: 0.35, blue: 0.25))
                .clipShape(.rect(topLeadingRadius: 16, topTrailingRadius: 16))
            
            ZStack {
                
                HStack(spacing: 0) {
                    ForEach(Array(week.days.enumerated()), id: \.element.id) { index, day in
                        
                        // Circle
                        let isCurrent = !isLocked && (day.id == week.days.first(where: { !$0.isCompleted })?.id)
                        let circleSize: CGFloat = isCurrent ? 70 : 60
                        ZStack {
                            Circle()
                                .fill(color(for: index, day: day))
                                .frame(width: circleSize, height: circleSize)
                            
                            if day.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(isCurrent ? .title.bold() : .title2)
                                    .foregroundStyle(isCurrent ? .white : Color("Brown-600"))
                            }
                        }
                        // Ensure the tap area is always consistent even when circle sizes differ
                        .frame(width: 72, height: 72)
                        .shadow(color: Color("Brown-500").opacity(isCurrent ? 0.5 : 0), radius: 8, x: 0, y: 4)
                        .onTapGesture {
                            let isAvailable = !isLocked && (day.id == week.days.first(where: { !$0.isCompleted })?.id)
                            popupState = WorkoutPopupState(
                                weekTitle: week.title,
                                day: day,
                                isAvailable: isAvailable,
                                onStart: {
                                    popupState = nil
                                    selectedDay = day
                                    navigateToMap = true
                                },
                                onMarkDone: {
                                    if let index = week.days.firstIndex(where: { $0.id == day.id }) {
                                        week.days[index].isCompleted = true
                                        try? week.modelContext?.save()
                                        // Update UserStats program progress
                                        stats?.recordDayCompleted(allWeeks: allWeeks)
                                        try? context.save()
                                    }
                                    popupState = nil
                                }
                            )
                        }
                        
                        if index < week.days.count - 1 {
                            HStack(spacing: 6) {
                                Circle().frame(width: 6, height: 6)
                                Circle().frame(width: 6, height: 6)
                                Circle().frame(width: 6, height: 6)
                            }
                            .foregroundColor(Color("Brown-500"))
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding()
            .background(Color(red: 1, green: 0.98, blue: 0.88))
            .cornerRadius(16)
            .opacity(isLocked ? 0.5 : 1.0)
        }
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
        .navigationDestination(isPresented: $navigateToMap){
            MainMapView(week: week, day: selectedDay, onRunComplete: {
                // Find the exact day and complete it
                if let day = selectedDay, let index = week.days.firstIndex(where: { $0.id == day.id }) {
                    week.days[index].isCompleted = true
                    try? week.modelContext?.save()
                }
                // Dismiss the map view
                navigateToMap = false
            })
        }
    }
    
    // Color the circles based on state
    func color(for index: Int, day: TrainingDay) -> Color {
        if isLocked {
            return Color.gray.opacity(0.2)
        }
        
        if day.isCompleted {
            return Color("green-200")
        }
        
        // Current actionable circle
        if index == week.days.firstIndex(where: { !$0.isCompleted }) {
            return Color("Brown-600")
        }
        
        // Unlocked but not yet the current one (future days in an unlocked week)
        return Color("Brown-200")
    }
}

#Preview {
    WeekCardView(
        week: RunningPlan.beginnerPlans[0],
        popupState: .constant(nil)
    )
    .padding()
}
