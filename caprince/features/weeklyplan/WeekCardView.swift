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
        VStack(alignment: .leading, spacing: 16) {
            
            Text(week.title)
                .font(.headline)
            
            ZStack {
                
                HStack(spacing: 0) {
                    ForEach(Array(week.days.enumerated()), id: \.element.id) { index, day in
                        
                        // Circle
                        ZStack {
                            Circle()
                                .fill(color(for: index, day: day))
                                .frame(width: 40, height: 40)
                            
                            if day.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.caption)
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
                            .foregroundColor(.brown.opacity(0.6))
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    func color(for index: Int, day: TrainingDay) -> Color {
        if day.isCompleted {
            return .green
        }
        
        if index == week.days.firstIndex(where: { !$0.isCompleted }) {
            return Color.orange.opacity(0.3)
        }
        
        return Color.gray.opacity(0.2)
    }
}
