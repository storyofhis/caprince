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
                    
                    GeometryReader { trackGeo in
                        let padding: CGFloat = 24
                        let actorSize: CGFloat = 48
                        let castleSize: CGFloat = 60
                        let lineHeight: CGFloat = 10
                        let prog = max(0, min(1, progress))
                        let trackLeft = padding
                        let castleX = trackGeo.size.width - padding - castleSize / 2
                        let trackWidth = castleX - trackLeft
                        let actorMinX = trackLeft + actorSize / 2
                        let actorMaxX = castleX - actorSize / 2 - 6
                        let actorCenterX = actorMinX + (actorMaxX - actorMinX) * prog
                        let filledWidth = max(0, actorCenterX - trackLeft)
                        let lineY: CGFloat = 56

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(red: 0.87, green: 0.89, blue: 0.85))
                                .frame(width: trackWidth, height: lineHeight)
                                .position(x: trackGeo.size.width / 2 - padding / 2, y: lineY)

                            Capsule()
                                .fill(progressColor)
                                .frame(width: filledWidth, height: lineHeight)
                                .position(x: trackLeft + filledWidth / 2, y: lineY)
                                .animation(.easeInOut(duration: 0.5), value: progress)

                            Image("castle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: castleSize, height: castleSize)
                                .position(x: castleX, y: lineY - 25)

                            Image("actorWidget")
                                .resizable()
                                .scaledToFit()
                                .frame(width: actorSize, height: actorSize)
                                .position(x: actorCenterX, y: lineY - 4)
                                .animation(.easeInOut(duration: 0.5), value: progress)
                        }
                    }
                    .frame(height: 110)

//                    HStack {
//                        ForEach(1...totalSteps, id: \.self) { step in
//                            Text("\(step)")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                                .foregroundStyle(Color(red: 0.39, green: 0.31, blue: 0.23))
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                    .padding(.horizontal, 24)
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
