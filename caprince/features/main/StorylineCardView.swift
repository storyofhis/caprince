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
                // Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Brown-300"), lineWidth: 2)
                    )
                // Content
                VStack {
                    // Space for Illustrations
                    illustration
                    
                    GeometryReader { trackGeo in
                        let padding: CGFloat = 30
                        let actorSize: CGFloat = 80
                        let castleSize: CGFloat = 80
                        let lineHeight: CGFloat = 14
                        let prog = max(0, min(1, progress))
                        let trackLeft = padding
                        let castleX = trackGeo.size.width - padding - castleSize / 4
                        let trackWidth = castleX - trackLeft
                        let actorMinX = trackLeft + actorSize / 2
                        let actorMaxX = castleX - castleSize / 3
                        let actorCenterX = actorMinX + (actorMaxX - actorMinX) * prog
                        let filledWidth = max(0, actorCenterX - trackLeft)
                        let lineY: CGFloat = 75

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(red: 0.87, green: 0.89, blue: 0.85))
                                .frame(width: trackWidth, height: lineHeight)
                                .position(x: trackLeft + trackWidth / 2, y: lineY)

                            Capsule()
                                .fill(progressColor)
                                .frame(width: filledWidth, height: lineHeight)
                                .position(x: trackLeft + filledWidth / 2, y: lineY)
                                .animation(.easeInOut(duration: 0.5), value: progress)

                            Image("castle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: castleSize, height: castleSize)
                                .position(x: castleX, y: lineY - 40)

                            Image("actorWidget")
                                .resizable()
                                .scaledToFit()
                                .frame(width: actorSize, height: actorSize)
                                .position(x: actorCenterX, y: lineY - 30)
                                .animation(.easeInOut(duration: 0.5), value: progress)
                        }
                    }
                    .frame(height: 90)
                }
            }
        }
        .frame(height: 100)
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
