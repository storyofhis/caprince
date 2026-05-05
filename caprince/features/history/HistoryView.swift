//
//  HistoryView.swift
//  caprince
//
//  Created by Antigravity on 24/04/26.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct HistoryView: View {
    @Query(sort: \RunSession.date, order: .reverse) private var runs: [RunSession]
    @Environment(\.dismiss) private var dismiss
    
    struct CodableCoordinate: Codable {
        let lat: Double
        let lon: Double
    }
    
    private func decodeCoordinates(data: Data?) -> [CLLocationCoordinate2D] {
        guard let data = data else { return [] }
        do {
            let decoded = try JSONDecoder().decode([CodableCoordinate].self, from: data)
            return decoded.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
        } catch {
            return []
        }
    }
    
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
                        HStack(alignment: .center, spacing: 16) {
                            if let routeData = run.routeData, !routeData.isEmpty {
                                let coords = decodeCoordinates(data: routeData)
                                if !coords.isEmpty {
                                    MapPolylineOverlay(coordinates: coords)
                                        .frame(width: 64, height: 64)
                                        .cornerRadius(12)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 64, height: 64)
                                        .overlay(
                                            Image(systemName: "map")
                                                .font(.system(size: 28))
                                                .foregroundColor(.green)
                                        )
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Image(systemName: "map")
                                            .font(.system(size: 28))
                                            .foregroundColor(.green)
                                    )
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(run.programName)
                                    .font(.headline)
                                Text(formatDateAndTime(run.date))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                HStack(spacing: 16) {
                                    Label("\(run.calories, specifier: "%.0f") kcal", systemImage: "flame")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                    Label(String(format: "%.2f Km", run.distance), systemImage: "leaf")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                    Label("\(run.steps) Steps", systemImage: "figure.walk")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 4)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Activities")
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
    
    private func formatDateAndTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d"
        return dateFormatter.string(from: date)
    }
}

struct MapPolylineOverlay: UIViewRepresentable {
    let coordinates: [CLLocationCoordinate2D]
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        mapView.delegate = context.coordinator
        if let first = coordinates.first {
            let region = MKCoordinateRegion(center: first, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: false)
        }
        return mapView
    }
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.green
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}

