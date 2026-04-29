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
                
                // Line
                GeometryReader { geo in
                    let width = geo.size.width
                    
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 3)
                        
                        Capsule()
                            .fill(Color.orange)
                            .frame(width: width * progress, height: 3)
                            .animation(.easeInOut, value: progress)
                    }
                    .offset(y: 16)
                }
                
                // Circles
                HStack {
                    ForEach(Array(week.days.enumerated()), id: \.element.id) { index, day in
                        
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
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selectedDay = day
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
