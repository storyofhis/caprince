//
//  HistoryView.swift
//  caprince
//
//  Created by Antigravity on 24/04/26.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \RunSession.date, order: .reverse) private var runs: [RunSession]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if runs.isEmpty {
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No runs yet. Go for a run!")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(runs) { run in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(run.date, style: .date)
                                .font(.headline)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Distance")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(String(format: "%.2f km", run.distance))
                                        .font(.system(.body, design: .monospaced))
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Duration")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(formatTime(run.duration))
                                        .font(.system(.body, design: .monospaced))
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Pace")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(run.averagePace)/km")
                                        .font(.system(.body, design: .monospaced))
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Run History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                print("📊 HistoryView appeared. Total runs: \(runs.count)")
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
