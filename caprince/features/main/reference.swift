//
//  reference.swift
//  caprince
//
//  Created by Clarissa Aditjakra on 01/05/26.
//

import SwiftUI

struct ReferenceView: View {
    @State private var sampleWeek = RunningPlan.beginnerPlans[0]
    @State private var selectedDay: TrainingDay? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: - Your Progress
                StorylineCardView()
                
                // MARK: - Weekly Report
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weekly Report")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        // Top Row
                        HStack(spacing: 16) {
                            // Steps Card
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 150)
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text("Steps")
                                            .font(.headline)
                                        Spacer()
                                        Text("3978").font(.title).fontWeight(.bold) + Text(" Steps").font(.caption)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                            
                            // Goal Card
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 150)
                                .overlay(
                                    VStack {
                                        Text("Goal")
                                            .font(.headline)
                                        Spacer()
                                        Text("75%")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    .padding()
                                )
                        }
                        
                        // Bottom Row
                        HStack(spacing: 16) {
                            // Calories Card
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 140, height: 140)
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text("Calories")
                                            .font(.headline)
                                        Spacer()
                                        Text("1056").font(.title2).fontWeight(.bold) + Text(" Kcal").font(.caption)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                            
                            // Running Card
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 140)
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text("Running")
                                            .font(.headline)
                                        Spacer()
                                        Text("2.7").font(.title2).fontWeight(.bold) + Text(" Km").font(.caption)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                )
                        }
                    }
                }
                
                // MARK: - Workout Plan
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Workout Plan")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text("See All Workouts")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Replaced wireframe with actual component
                    WeekCardView(week: $sampleWeek, selectedDay: $selectedDay)
                }
            }
            .padding(24)
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ReferenceView()
}
