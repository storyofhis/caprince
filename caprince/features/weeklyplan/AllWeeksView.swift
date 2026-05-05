//
//  ViewAllWeeks.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 04/05/26.
//

import SwiftUI
import SwiftData

struct ViewAllWeeks: View {
    @Environment(\.dismiss) var dismiss
    @Query(sort: \TrainingWeek.title) var weeks: [TrainingWeek]
    @Environment(\.modelContext) private var context
    @State private var popupState: WorkoutPopupState? = nil
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(weeks.indices, id: \.self) { index in
                        let isLocked = index > 0 && weeks[index - 1].days.filter({ $0.isCompleted }).count < 2
                        WeekCardView(week: weeks[index], popupState: $popupState, isLocked: isLocked)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .background(Color(red: 0.99, green: 0.99, blue: 0.99)) // TODO: msut be replaced with global background
            
            // Custom Popup Overlay
            if let state = popupState {
                WorkoutDetailSheet(
                    weekTitle: state.weekTitle,
                    day: state.day,
                    isAvailable: state.isAvailable,
                    onStart: state.onStart,
                    onMarkDone: state.onMarkDone,
                    onDismiss: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            popupState = nil
                        }
                    }
                )
                .zIndex(100)
                .transition(.move(edge: .bottom))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back Button
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
                }
            }
            
            // Custom Title
            ToolbarItem(placement: .principal) {
                Text("All Workouts")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.39, green: 0.31, blue: 0.23))
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TrainingWeek.self, configurations: config)
    
    for week in RunningPlan.beginnerPlans {
        container.mainContext.insert(week)
    }

    return NavigationStack {
        ViewAllWeeks()
    }
    .modelContainer(container)
}
