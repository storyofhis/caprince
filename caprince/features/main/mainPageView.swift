//
//  mainPageView.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 01/05/26.
//

// TODO: Fix skeleton, make it less hardcodey
// TODO: Clean up storyline preview

import SwiftUI

struct mainPageView: View {
    // Sample data for weekly workout plan card
    @State private var sampleWeek = RunningPlan.beginnerPlans[0]
    @State private var selectedDay: TrainingDay? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                
                // Storyline/Widget
                VStack(alignment: .leading){
                    Text("Your Progress")
                        .font(Font.title2.bold())
                        .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                    
                    StorylinePreview()
                }
                
                // Weekly Report
                VStack(alignment: .leading){
                    Text("Weekly Report")
                        .font(Font.title2.bold())
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
                                .overlay(
                                    VStack(alignment: .leading, spacing: 34) {
                                        Text("Steps")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        HStack(alignment: .lastTextBaseline) {
                                            Text("3978")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            Text("Steps")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                            
                            // Goal
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                                .frame(width: 110, height: 130)
                                .overlay(
                                    VStack {
                                        Text("Goal")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        Text("75%")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                )
                        }
                        
                        // Bottom row
                        HStack {
                            // Calories
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                                .frame(width: 154, height: 130)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 34) {
                                        Text("Calories")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        HStack(alignment: .lastTextBaseline) {
                                            Text("3978")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            Text("kcal")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                            
                            // Running Distance
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(red: 0.64, green: 0.74, blue: 0.55))
                                .frame(width: 154, height: 130)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 34) {
                                        Text("Running")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        HStack(alignment: .lastTextBaseline) {
                                            Text("2.7")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            Text("Km")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                        }
                    }
                }
                
                // Workout Plan
                VStack(alignment: .leading){
                    // Title + Including view all
                    HStack {
                        Text("Workout Plan")
                            .font(Font.title2.bold())
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
}

#Preview {
    mainPageView()
}
