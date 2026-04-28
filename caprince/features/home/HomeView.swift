//
//  HomeView.swift
//  caprince
//
//  Created by Antigravity on 24/04/26.
//

import SwiftUI

struct TrainingDay: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
}

struct TrainingWeek: Identifiable {
    let id = UUID()
    let title: String
    let days: [TrainingDay]
}

struct HomeView: View {
    @State private var selectedTab = "Beginner 5K"
    private let tabs = ["Beginner 5K"]
    
    private let beginnerPlans: [TrainingWeek] = [
        TrainingWeek(
            title: "Week 1",
            days: [
                TrainingDay(title: "Day 1", duration: "20 min walk/run"),
                TrainingDay(title: "Day 2", duration: "20 min walk/run"),
                TrainingDay(title: "Day 3", duration: "20 min walk/run")
            ]
        ),
        TrainingWeek(
            title: "Week 2",
            days: [
                TrainingDay(title: "Day 1", duration: "22 min"),
                TrainingDay(title: "Day 2", duration: "22 min"),
                TrainingDay(title: "Day 3", duration: "22 min")
            ]
        ),
        TrainingWeek(
            title: "Week 3",
            days: [
                TrainingDay(title: "Day 1", duration: "22 min"),
                TrainingDay(title: "Day 2", duration: "22 min"),
                TrainingDay(title: "Day 3", duration: "22 min")
            ]
        ),
        TrainingWeek(
            title: "Week 4",
            days: [
                TrainingDay(title: "Day 1", duration: "22 min"),
                TrainingDay(title: "Day 2", duration: "22 min"),
                TrainingDay(title: "Day 3", duration: "22 min")
            ]
        ),
        TrainingWeek(
            title: "Week 5",
            days: [
                TrainingDay(title: "Day 1", duration: "22 min"),
                TrainingDay(title: "Day 2", duration: "22 min"),
                TrainingDay(title: "Day 3", duration: "22 min")
            ]
        ),
        TrainingWeek(
            title: "Week 6",
            days: [
                TrainingDay(title: "Day 1", duration: "22 min"),
                TrainingDay(title: "Day 2", duration: "22 min"),
                TrainingDay(title: "Day 3", duration: "22 min")
            ]
        )
    ]
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome Back!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Ready to train?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal)
            .padding(.top)
            
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
                    ForEach(beginnerPlans) { plan in
                        NavigationLink(destination: WeekDetailView(week: plan)) {
                            HStack(spacing: 16) {
                                
                                // Simple icon (static for now)
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "calendar")
                                        .foregroundColor(.orange)
                                        .font(.title3)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(plan.title)
                                        .font(.headline)
                                    
                                    Text("\(plan.days.count) workouts this week")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Start Run Button
            VStack {
                NavigationLink(destination: MapView()) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("FREE RUN")
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .cornerRadius(16)
                    .shadow(color: .orange.opacity(0.3), radius: 10, y: 5)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
