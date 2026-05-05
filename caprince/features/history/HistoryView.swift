import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \RunSession.date, order: .reverse) private var runs: [RunSession]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        if runs.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "figure.walk")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("No activities yet")
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 100)
                        } else {
                            ForEach(runs) { run in
                                activityCard(run: run)
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Activities")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    
    // MARK: - Card View
    private func activityCard(run: RunSession) -> some View {
        let wd = weekAndDay(from: run.date)
        
        return VStack(alignment: .leading, spacing: 10) {
            
            Text("Week \(wd.week) Day \(wd.day)")
                .font(.headline)
                .foregroundColor(.brown)
            
            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                
                Text("\(formatDate(run.date)) | \(formatTimeRange(run.date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 20) {
                Label("\(Int(run.calories)) kcal", systemImage: "flame")
                    .foregroundColor(.green)
                
                Label(String(format: "%.1f Km", run.distance), systemImage: "location")
                    .foregroundColor(.orange)
                
                Label("\(run.steps) Steps", systemImage: "figure.walk")
                    .foregroundColor(.brown)
            }
            .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Week & Day Logic
    private func weekAndDay(from date: Date) -> (week: Int, day: Int) {
        guard let firstDate = runs.last?.date else {
            return (1, 1)
        }
        
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: firstDate, to: date).day ?? 0
        
        let week = (days / 7) + 1
        let day = (days % 7) + 1
        
        return (week, day)
    }
    
    // MARK: - Formatters
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d"
        return formatter.string(from: date)
    }
    
    private func formatTimeRange(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        
        let start = formatter.string(from: date)
        let end = formatter.string(from: date.addingTimeInterval(60 * 60))
        
        return "\(start) - \(end)"
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
