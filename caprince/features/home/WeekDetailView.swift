//
//  WeekDetailView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 28/04/26.
//

import SwiftUI

struct WeekDetailView: View {
    let week: TrainingWeek
    
    var body: some View {
        List {
            ForEach(week.days) { day in
                HStack {
                    VStack(alignment: .leading) {
                        Text(day.title)
                            .font(.headline)
                        Text(day.duration)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(week.title)
    }
}
