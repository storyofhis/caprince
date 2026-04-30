//
//  WorkoutDetailSheet.swift
//  caprince
//
//  Created by Maula Izza Azizi on 29/04/26.
//

import SwiftUI

struct WorkoutDetailSheet: View {
    let day: TrainingDay
    var onStart: () -> Void
    
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
        }
        .padding()
    }
}
