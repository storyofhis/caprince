//
//  WeekCardView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 29/04/26.
//

import SwiftUI

struct WeekCardView: View {

    @State private var navigateToMap = false
    @Binding var week: TrainingWeek
    @Binding var selectedDay: TrainingDay?
    
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
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.title2)
                            }
                        }
                        .onTapGesture {
                            selectedDay = day
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
        }
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
    }
    
    // Color the 1, 2, 3 buttons
    func color(for index: Int, day: TrainingDay) -> Color {
        if day.isCompleted {
            return .green
        }
        
        if index == week.days.firstIndex(where: { !$0.isCompleted }) {
            return Color("Brown-200")
        }
        
        return Color.gray.opacity(0.2)
    }
}

#Preview {
    WeekCardView(
        week: .constant(RunningPlan.beginnerPlans[0]),
        selectedDay: .constant(nil)
    )
    .padding()
}
