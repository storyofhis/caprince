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

    // Drag-to-dismiss state
    @State private var dragOffset: CGFloat = 0
    private let dismissThreshold: CGFloat = 120

    var body: some View {
        ZStack {
            // Tap-outside to dismiss
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack {
                Spacer()

                // Bottom sheet card — slides up, drags down to dismiss
                VStack(spacing: 0) {
                    // Drag pill — grabbable handle
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.82, green: 0.78, blue: 0.74))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity) // widen tap area
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Only allow dragging downward
                                    if value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > dismissThreshold {
                                        // Dragged far enough — dismiss
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            onDismiss()
                                        }
                                    } else {
                                        // Not far enough — snap back
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )

                    // Title
                    Text("\(weekTitle) \(day.title)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.39, green: 0.31, blue: 0.23))
                        .padding(.bottom, 20)

                    // Bullet list
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(formatDurationIntoBullets(day.duration), id: \.self) { bullet in
                            HStack(alignment: .center, spacing: 12) {
                                Circle()
                                    .fill(Color(red: 0.82, green: 0.72, blue: 0.60))
                                    .frame(width: 10, height: 10)
                                Text(bullet)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.25, green: 0.20, blue: 0.15))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)

                    Spacer().frame(height: 32)

                    // Action button
                    if day.isCompleted {
                        Text("✓ Completed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("green-200"))
                            .clipShape(Capsule())
                            .padding(.horizontal, 28)
                    } else if isAvailable {
                        Button(action: { onStart() }) {
                            Text("Go!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.39, green: 0.31, blue: 0.23))
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 28)
                    } else {
                        Text("🔒 Locked")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Capsule())
                            .padding(.horizontal, 28)
                    }

                    // Safe-area bottom padding
                    Spacer().frame(height: 36)
                }
                .background(Color(red: 1.0, green: 0.98, blue: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: -4)
                // Follow the user's finger while dragging
                .offset(y: dragOffset)
                // Slide in from bottom
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    // Helper to format the long string into clean bullet points
    private func formatDurationIntoBullets(_ duration: String) -> [String] {
        if duration == "Race Day!" {
            return ["Race Day! 🏁"]
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
