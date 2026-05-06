//
//  mainPageView.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 01/05/26.
//

// TODO: Fix skeleton, make it less hardcodey

import SwiftUI
import SwiftData
import HealthKit

struct mainPageView: View {
    @Query(sort: \TrainingWeek.title) var weeks: [TrainingWeek]
    @Query var userStatsQuery: [UserStats]
    @State private var popupState: WorkoutPopupState? = nil
    @StateObject private var healthKit = HealthKitManager.shared
    
    // Safely access the single UserStats singleton
    var stats: UserStats? { userStatsQuery.first }
    
    var activeWeek: TrainingWeek? {
        weeks.first(where: { !$0.days.allSatisfy { $0.isCompleted } }) ?? weeks.last
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 48) {
                    // Top Section: Progress + Grid (Closer together)
                    VStack(spacing: 16) {
                        // Storyline/Widget
                    VStack(alignment: .leading){
                        Text("Your Progress")
                            .font(Font.title2.bold())
                            .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
                        
                        StorylineCardView(progress: stats?.programProgress ?? 0)
                    }
                    
                    // Grid
                    VStack{
                        // Top row
                        HStack(spacing: 16) {
                            // Steps
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Brown-300"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 91)
                                .overlay(alignment: .bottomTrailing) {
                                    Image("WR-Steps")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                        .offset(x: 10, y: 5)
                                }
                                .overlay(alignment: .topLeading) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Steps")
                                            .font(.title3.bold())
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(healthKit.stepCount))")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Avg Pace
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Brown-500"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 91)
                                .overlay(alignment: .bottomTrailing) {
                                    Circle()
                                        .fill(Color(red: 0.64, green: 0.74, blue: 0.55))
                                        .frame(width: 60, height: 60)
                                        .blur(radius: 15)
                                        .offset(x: 20, y: 20)
                                }
                                .overlay(alignment: .topLeading) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Avg. Pace")
                                            .font(.title3.bold())
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Text(stats?.formattedAveragePace ?? "00:00")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // Bottom row
                        HStack(spacing: 16) {
                            // Calories
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Brown-500"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 91)
                                .overlay(alignment: .bottomTrailing) {
                                    Image("WR-Calories")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 45)
                                        .offset(x: 0, y: 5)
                                }
                                .overlay(alignment: .topLeading) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Calorie")
                                            .font(.title3.bold())
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                                            Text(String(format: "%.0f", healthKit.caloriesBurned))
                                                .font(.system(size: 32, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            Text("Kcal")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Running Distance
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Brown-300"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 91)
                                .overlay(alignment: .bottomTrailing) {
                                    Image("WR-Running")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .offset(x: 5, y: 5)
                                }
                                .overlay(alignment: .topLeading) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Distance")
                                            .font(.title3.bold())
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                                            Text(String(format: "%.0f", stats?.totalDistanceKm ?? 0))
                                                .font(.system(size: 32, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            Text("Km")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
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
                                Text("All Workout")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color("Brown-500"))
                                    .clipShape(Capsule())
                            }
                        }
                        
                        // Week card view — shows the current active week
                        if let currentWeek = activeWeek {
                            ActiveWeekCardView(week: currentWeek, popupState: $popupState)
                        }
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            } // Closes ScrollView
            .onAppear {
                healthKit.requestAuthorization()
            }
            
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
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TrainingWeek.self, configurations: config)
    
    for week in RunningPlan.beginnerPlans {
        container.mainContext.insert(week)
    }
    
    return NavigationStack {
        mainPageView()
    }
    .modelContainer(container)
}

