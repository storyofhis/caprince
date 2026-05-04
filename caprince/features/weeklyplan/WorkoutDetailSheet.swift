//
//  WorkoutDetailSheet.swift
//  caprince
//
//  Created by Maula Izza Azizi on 29/04/26.
//

import SwiftUI

struct WorkoutDetailSheet: View {
    let day: TrainingDay
    var isAvailable: Bool
    var onStart: () -> Void
    var onMarkDone: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(day.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(day.duration)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if day.isCompleted {
                Button {
                    // Do nothing
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Completed")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(true)
            } else if isAvailable {
                VStack(spacing: 12) {
                    Button {
                        onStart()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Run")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    // Temporary test button to easily mark as done
                    Button {
                        onMarkDone()
                    } label: {
                        Text("Mark as Done (Test)")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
            } else {
                Button {
                    // Do nothing
                } label: {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("Locked")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(true)
            }
        }
        .padding()
    }
}
