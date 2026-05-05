//
//  mainPageView.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 01/05/26.
//

// TODO: Fix skeleton, make it less hardcodey

import SwiftUI

struct mainPageView: View {
    // Sample data for weekly workout plan card
    @State private var sampleWeek = RunningPlan.beginnerPlans[0]
    @State private var popupState: WorkoutPopupState? = nil
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20){
                
                // Storyline/Widget
                VStack(alignment: .leading){
                    Text("Your Progress")
                        .font(Font.title2.bold())
                        .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                    
                    StorylineCardView()
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
                            // TODO: Nanti ganti foregroundstyle dengan fill kalau udah ad warnanya di asset!!
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
                                .overlay(alignment: .bottomTrailing) {
                                    Image("WR-Steps")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 90)
                                        .offset(x: 8, y: 10)
                                }
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
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Goal
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                                .frame(width: 110, height: 130)
                                .overlay(alignment: .bottom) {
                                    Circle()
                                        .fill(Color(red: 0.64, green: 0.74, blue: 0.55))
                                        .frame(width: 80, height: 80)
                                        .blur(radius: 20)
                                        .offset(y: 40)
                                }
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
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // Bottom row
                        HStack {
                            // Calories
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                                .frame(width: 154, height: 130)
                                .overlay(alignment: .bottomTrailing) {
                                    Image("WR-Calories")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                        .offset(x: 0, y: 2)
                                }
                                .overlay(
                                    VStack(alignment: .leading, spacing: 34) {
                                        Text("Calories")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        HStack(alignment: .lastTextBaseline) {
                                            Text("1056") // Updated to match your image!
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            Text("Kcal")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Running Distance
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(red: 0.64, green: 0.74, blue: 0.55))
                                .frame(width: 154, height: 130)
                                .overlay(alignment: .bottomTrailing) {
                                    Image("WR-Running")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .offset(x: 2, y: 10)
                                }
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
                                .clipShape(RoundedRectangle(cornerRadius: 10))
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
                        
                        NavigationLink(destination: ViewAllWeeks()){
                            Text("View All Workouts")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Week card view
                    WeekCardView(week: $sampleWeek, popupState: $popupState)
                }
            }
            .padding(38)
        } // Closes ScrollView
            
        // Custom Popup Overlay
        if let state = popupState {
                WorkoutDetailSheet(
                    weekTitle: state.weekTitle,
                    day: state.day,
                    isAvailable: state.isAvailable,
                    onStart: state.onStart,
                    onMarkDone: state.onMarkDone,
                    onDismiss: {
                        popupState = nil
                    }
                )
                .zIndex(100)
            }
        }
<<<<<<< Updated upstream
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: popupState != nil)
=======
        .onAppear {
            viewModel.requestHealthData()
        }
>>>>>>> Stashed changes
    }
}

#Preview {
    NavigationStack {
        mainPageView()
    }
}

