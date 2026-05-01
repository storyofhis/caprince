//
//  StorylinePreview.swift
//  caprince
//

import SwiftUI

struct StorylinePreview: View {
    // Progress value from 0.0 to 1.0
    var progress: CGFloat = 0.4
    var totalSteps: Int = 3
    
    var body: some View {
        GeometryReader { geometry in
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
                VStack(spacing: 0) {
                    
                    // Top area reserved for scalable illustrations later
                    Spacer()
                    
                    // Progress Bar Section
                    VStack(spacing: 12) {
                        
                        // Custom Progress Bar Track
                        GeometryReader { barGeometry in
                            ZStack(alignment: .leading) {
                                // Background Track (Light)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.87, green: 0.89, blue: 0.85).opacity(0.8))
                                    .frame(height: 10)
                                
                                // Filled Track (Dark Green)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.37, green: 0.44, blue: 0.32))
                                    // Scale width based on progress (clamped between 0 and 1)
                                    .frame(width: barGeometry.size.width * max(0, min(1, progress)), height: 10)
                                    // Smooth animation whenever progress changes
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                            }
                        }
                        .frame(height: 10) // Fixed height for the bar itself
                        .padding(.horizontal, 24) // Indent bar from edges
                        
                        // Step Numbers aligned underneath
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
        }
        // Maintains the wide card aspect ratio automatically, making it perfect for Widgets!
        .aspectRatio(2.0, contentMode: .fit)
    }
}

#Preview {
    // Preview showing different states to test flexibility
    VStack(spacing: 30) {
        StorylinePreview(progress: 0.1)
        StorylinePreview(progress: 0.5)
        StorylinePreview(progress: 1.0)
    }
    .padding()
}
