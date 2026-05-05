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
                        ZStack {
                            Circle()
                                .fill(color(for: index, day: day))
                                .frame(width: 60, height: 60)
                            
                            if day.isCompleted {
                                Text("\(index + 1)")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.title2)
                            }
                        }
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
                            .foregroundColor(Color("Brown-600"))
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
            MainMapView(onRunComplete: {
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
    
    // Color the 1, 2, 3 buttons
    func color(for index: Int, day: TrainingDay) -> Color {
        if isLocked {
            return Color.gray.opacity(0.2)
        }
        
        if day.isCompleted {
            return Color("green-200")
        }
        
        if index == week.days.firstIndex(where: { !$0.isCompleted }) {
            return Color("Brown-200")
        }
        
        return Color.gray.opacity(0.2)
    }
}

#Preview {
    WeekCardView(
        week: RunningPlan.beginnerPlans[0],
        popupState: .constant(nil)
    )
    .padding()
}
