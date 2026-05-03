//
//  MapComponent.swift
//  caprince
//
//  Created by Bernardus William Santosa on 03/05/26.
//

import SwiftUI
import MapKit

struct MapComponent: View {
    @Binding var coordinates: [CLLocationCoordinate2D]
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        Map(position: $cameraPosition) {
            
            if !coordinates.isEmpty {
                MapPolyline(coordinates: coordinates)
                    .stroke(.green, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
            }
            
            UserAnnotation()
        }
    }
}

struct StatView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 100)
    }
}

struct ControlButtonView: View {
    var icon: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background(color)
                .clipShape(Circle())
        }
    }
}
