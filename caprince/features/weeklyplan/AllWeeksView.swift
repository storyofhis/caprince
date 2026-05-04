//
//  ViewAllWeeks.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 04/05/26.
//

import SwiftUI

struct ViewAllWeeks: View {
    @Environment(\.dismiss) var dismiss
    @State private var weeks: [TrainingWeek] = RunningPlan.beginnerPlans
    @State private var selectedDay: TrainingDay? = nil
    @State private var navigateToMap = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach($weeks) { $week in
                    WeekCardView(navigateToMap: $navigateToMap, week: $week, selectedDay: $selectedDay)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(red: 0.99, green: 0.99, blue: 0.99)) // TODO: msut be replaced with global background
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
        .navigationDestination(isPresented: $navigateToMap) {
            MainMapView()
        }
    }
}

#Preview {
    NavigationStack {
        ViewAllWeeks()
    }
}
