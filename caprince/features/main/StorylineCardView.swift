//
//  StorylineCardView.swift
//  caprince
//

import SwiftUI

struct StorylineCardView<Content: View>: View {
    // Progress Variables
    var progress: CGFloat = 0.4
    var totalSteps: Int = 3
    var progressColor: Color
    let illustration: Content
    
    init(progress: CGFloat = 0.4, totalSteps: Int = 3, progressColor: Color = Color(red: 0.37, green: 0.44, blue: 0.32), @ViewBuilder illustration: () -> Content) {
        self.progress = progress
        self.totalSteps = totalSteps
        self.progressColor = progressColor
        self.illustration = illustration()
    }
    
    var body: some View {
        GeometryReader {
            geometry in
            // Geometry reader for flexibility in progress bar
            ZStack {
                // Background Gradient
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
                
                // Content
                VStack {
                    // Space for Illustrations
                    illustration
                    
                    // Progress Bar Section
                    GeometryReader { barGeometry in
                        ZStack(alignment: .leading) {
                            // Background Track (Light)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.87, green: 0.89, blue: 0.85).opacity(0.8))
                                .frame(height: 10)
                            
                            // Filled Track
                            RoundedRectangle(cornerRadius: 8)
                                .fill(progressColor)
                                // Scale width based on progress (clamped between 0 and 1)
                                .frame(width: barGeometry.size.width * max(0, min(1, progress)), height: 10)
                                // Smooth animation whenever progress changes
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                        }
                    }
                    .frame(height: 10) // Fixed height for the bar itself
                    .padding(.horizontal, 24) // Indent bar from edges
                    
                    // Step/Section Numbers aligned underneath
                    HStack {
                        ForEach(1...totalSteps, id: \.self) { step in
                            Text("\(step)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23)) // Brand Brown
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.bottom, 20)
            }
        }
        // maintains the aspect ratio automatically
        .aspectRatio(2.0, contentMode: .fit)
    }
}

// Extension to provide a default Spacer when no illustration is passed
extension StorylineCardView where Content == Spacer {
    init(progress: CGFloat = 0.4, totalSteps: Int = 3, progressColor: Color = Color(red: 0.37, green: 0.44, blue: 0.32)) {
        self.init(progress: progress, totalSteps: totalSteps, progressColor: progressColor) {
            Spacer()
        }
    }
}

#Preview {
    StorylineCardView()
}
