//
//  mainPageView.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 01/05/26.
//

import SwiftUI

struct mainPageView: View {
    // Sample data for weekly workout plan card
    @State private var sampleWeek = RunningPlan.beginnerPlans[0]
    @State private var selectedDay: TrainingDay? = nil
    
    var body: some View {
        VStack(spacing: 26){
            
            // Storyline/Widget
            VStack(alignment: .leading){
                Text("Your Progress")
                    .font(Font.title3.bold())
                    .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.88), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.64, green: 0.74, blue: 0.55), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0.71),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: 320, height: 160)
            }
            
            // Weekly Report
            VStack(alignment: .leading){
                Text("Weekly Report")
                    .font(Font.title3.bold())
                    .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                
                // Grid
                VStack{
                    // Top row
                    HStack{
                        // Steps
                        // TODO: Nanti ganti foregroundstyle with fill kalau udah ad warnanya di asset!!
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.37, green: 0.44, blue: 0.32), location: 0.28),
                                        Gradient.Stop(color: Color(red: 0.71, green: 0.84, blue: 0.62), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0.5),
                                    endPoint: UnitPoint(x: 1.06, y: 0.5)
                                )
                            )
                            .frame(width: 198, height: 130)
                        
                        // Goal
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                            .frame(width: 110, height: 130)
                    }
                    
                    // Bottom row
                    HStack {
                        // Calories
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                            .frame(width: 154, height: 130)
                        
                        
                        // Running Distance
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(red: 0.64, green: 0.74, blue: 0.55))
                            .frame(width: 154, height: 130)
                    }
                }
            }
            
            // Workout Plan
            VStack(alignment: .leading){
                // Title + Including view all
                HStack {
                    Text("Workout Plan")
                        .font(Font.title3.bold())
                        .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                    Spacer()
                    Text("View All Workouts")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
               
                // Week card view
                WeekCardView(week: $sampleWeek, selectedDay: $selectedDay)
            }
        }
        .padding(38)
    }
}

#Preview {
    mainPageView()
}
