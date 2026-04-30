//
//  HomeView.swift
//  caprince
//
//  Created by Antigravity on 24/04/26.
//

import SwiftUI

<<<<<<< Updated upstream
struct TrainingPlan: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct HomeView: View {
    @State private var selectedTab = "Beginner 5K"
    private let tabs = ["Beginner 5K", "10K Prep", "Half Marathon"]
    
    private let beginnerPlans = [
        TrainingPlan(title: "Week 1: Easy Start", description: "3x 20 min walk/run", icon: "figure.run", color: .green),
        TrainingPlan(title: "Week 2: Building Base", description: "3x 25 min steady run", icon: "bolt.fill", color: .green),
        TrainingPlan(title: "Week 3: Push Further", description: "1x 30 min, 2x 20 min", icon: "flame.fill", color: .orange),
        TrainingPlan(title: "Week 4: Race Ready", description: "1x 5k run", icon: "flag.checkered", color: .red)
    ]
=======
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
>>>>>>> Stashed changes
    
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
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(plan.color.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                Image(systemName: plan.icon)
                                    .foregroundColor(plan.color)
                                    .font(.title3)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(plan.title)
                                    .font(.headline)
                                Text(plan.description)
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
