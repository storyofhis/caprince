//
//  MapView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        ZStack {
            
            // 🗺 Map + route
            Map(position: $viewModel.cameraPosition) {
                if !viewModel.route.isEmpty {
                    MapPolyline(coordinates: viewModel.route)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            
            VStack {
                
                // ⏱ TIMER (TOP)
                Text(viewModel.formatTime(viewModel.elapsedTime))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)
                
                Spacer()
                
                // 📏 DISTANCE CARD
                VStack(spacing: 8) {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(viewModel.totalDistance() / 1000, specifier: "%.2f") km")
                        .font(.title2)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // 🎮 CONTROLS
                HStack {
                    
                    Button("Start") {
                        viewModel.startTracking()
                    }
                    .padding()
                    .background(viewModel.isTracking ? .gray : .green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isTracking)
                    
                    Button("Stop") {
                        viewModel.stopTracking()
                    }
                    .padding()
                    .background(viewModel.isTracking ? .red : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!viewModel.isTracking)
                    
                    Spacer()
                    
                    // 📍 Recenter
                    Button {
                        viewModel.recenter()
                    } label: {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                }
                .padding()
            }
        }
    }
}
