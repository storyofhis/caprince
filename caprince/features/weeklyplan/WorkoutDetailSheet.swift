//
//  WorkoutDetailSheet.swift
//  caprince
//
//  Created by Maula Izza Azizi on 29/04/26.
//

import SwiftUI

struct WorkoutPopupState: Identifiable {
    let id = UUID()
    let weekTitle: String
    let day: TrainingDay
    let isAvailable: Bool
    let onStart: () -> Void
    let onMarkDone: () -> Void
}

struct WorkoutDetailSheet: View {
    let weekTitle: String
    let day: TrainingDay
    var isAvailable: Bool
    var onStart: () -> Void
    var onMarkDone: () -> Void
    var onDismiss: () -> Void

    
    var body: some View {
        ZStack {
            // Very subtle white/blur overlay instead of heavy blur or dark black
            Color.clear
                .background(Color.white.opacity(0.3))
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            ZStack(alignment: .top) {
                // Capybara
                Image("WDS-Capy")
                    .zIndex(1.0)
                
                // Main Card Container
                VStack(spacing: 0) {
                    // Space for the capybara to pop out
                    Spacer().frame(height: 44)
                    
                    ZStack(alignment: .top) {
                        // Glassmorphism / White card background
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.95))
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .frame(width: 268, height: 228) // Exact requested frame
                        
                        // Close button (Top Right)
                        HStack {
                            Spacer()
                            Button(action: {
                                onDismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color("Brown-600"))
                                    .frame(width: 28, height: 28)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 1.5)
                                    )
                            }
                            .padding(.top, 12)
                            .padding(.trailing, 12)
                        }
                        .frame(width: 268)
                        
                        // Main Content
                        VStack(spacing: 10) {
                            // Title
                            Text("\(weekTitle) \(day.title)")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(Color("Brown-600"))
                                .padding(.top, 24) // Space for capybara
                            
                            // Bullets
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(formatDurationIntoBullets(day.duration), id: \.self) { bullet in
                                    HStack(alignment: .top, spacing: 6) {
                                        Text("•")
                                            .font(.system(size: 16, weight: .bold))
                                        Text(bullet.capitalized)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 30)
                            
                            Spacer(minLength: 0)
                            
                            // Button Group
                            VStack(spacing: 6) {
                                if day.isCompleted {
                                    Button {
                                        // Do nothing
                                    } label: {
                                        Text("Completed")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .frame(width: 120, height: 36)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(18)
                                    }
                                    .disabled(true)
                                } else if isAvailable {
                                    Button {
                                        onStart()
                                    } label: {
                                        Text("Go!")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .frame(width: 120, height: 36)
                                            .background(Color("Brown-500"))
                                            .foregroundColor(.white)
                                            .cornerRadius(18)
                                    }
                                    
                                    // Temporary test button
                                    Button {
                                        onMarkDone()
                                    } label: {
                                        Text("Mark as Done")
                                            .font(.system(size: 10))
                                            .foregroundColor(.blue)
                                    }
                                } else {
                                    Button {
                                        // Do nothing
                                    } label: {
                                        Text("Locked")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .frame(width: 120, height: 36)
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(18)
                                    }
                                    .disabled(true)
                                }
                            }
                            .padding(.bottom, 16)
                        }
                        .frame(width: 268, height: 228)
                    }
                }
                
                // Capybara Image Overlay
                Image("capybara_crown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .offset(y: 0)
            }
        }
    }
    
    // Helper to format the long string into clean bullet points
    private func formatDurationIntoBullets(_ duration: String) -> [String] {
        if duration == "Race Day!" {
            return ["Race Day!"]
        }
        
        var result: [String] = []
        let components = duration.components(separatedBy: " ")
        var currentBullet = ""
        
        for word in components {
            if word == "&" || word == "+" {
                if !currentBullet.isEmpty {
                    result.append(currentBullet.trimmingCharacters(in: .whitespaces))
                }
                currentBullet = ""
            } else if word.lowercased() == "repeat" {
                if !currentBullet.isEmpty {
                    result.append(currentBullet.trimmingCharacters(in: .whitespaces))
                }
                currentBullet = "Repeat"
            } else {
                currentBullet += (currentBullet.isEmpty ? "" : " ") + word
            }
        }
        
        if !currentBullet.isEmpty {
            result.append(currentBullet.trimmingCharacters(in: .whitespaces))
        }
        
        return result
    }
}

#Preview {
    WorkoutDetailSheet(
        weekTitle: "Week 1",
        day: RunningPlan.beginnerPlans[0].days[0],
        isAvailable: true,
        onStart: {},
        onMarkDone: {},
        onDismiss: {}
    )
}
