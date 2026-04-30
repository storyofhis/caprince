//
//  HomeView.swift
//  caprince
//
//  Created by Antigravity on 24/04/26.
//

import SwiftUI

//struct TrainingDay: Identifiable {
//    let id = UUID()
//    let title: String
//    let duration: String
//    var isCompleted: Bool = false 
//}
//
//struct TrainingWeek: Identifiable {
//    let id = UUID()
//    let title: String
//    var days: [TrainingDay]
//}

struct HomeView: View {
    @State private var selectedTab = "Training Programme 5K"
    private let tabs = ["Training Programme 5K"]
    @State private var navigateToMap = false
    @State private var selectedDay: TrainingDay?
    @State private var showHistory = false
    @State private var beginnerPlans = RunningPlan.beginnerPlans
    
    var overallProgress: CGFloat {
        let totalDays = beginnerPlans.flatMap { $0.days }.count
        let completedDays = beginnerPlans.flatMap { $0.days }.filter { $0.isCompleted }.count
        return totalDays > 0 ? CGFloat(completedDays) / CGFloat(totalDays) : 0
    }
    
    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome To Caprince")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Ready to train?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button(action: { showHistory = true }) {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Progress")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int(overallProgress * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(Color.orange)
                            .frame(width: 300 * overallProgress, height: 8)
                            .animation(.easeInOut, value: overallProgress)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // Segmented Control
                Picker("Training Plan", selection: $selectedTab) {
                    ForEach(tabs, id: \.self) { tab in
                        Text(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            
                // Training Plan List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach($beginnerPlans) { $plan in
                            WeekCardView(
                                week: $plan,
                                selectedDay: $selectedDay
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Overlay when day is selected
            if let day = selectedDay {
                ZStack {
                    // Background dim - fully opaque to hide everything behind
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()
                        .onTapGesture {
                            selectedDay = nil
                        }
                    
                    // Center popup
                    WorkoutDetailSheet(day: day) {
                        // Mark day as completed and navigate
                        for i in 0..<beginnerPlans.count {
                            if let dayIndex = beginnerPlans[i].days.firstIndex(where: { $0.id == day.id }) {
                                beginnerPlans[i].days[dayIndex].isCompleted = true
                            }
                        }
                        navigateToMap = true
                        selectedDay = nil
                    }
                    .frame(maxWidth: 300, maxHeight: 280)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 20)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: selectedDay != nil)
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToMap) {
            MapView()
        }
        .sheet(isPresented: $showHistory) {
            HistoryView()
        }
    }
}

#Preview {
    HomeView()
}
