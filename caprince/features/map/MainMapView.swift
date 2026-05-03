//
//  MapView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showHistory = false
    @State private var showFinishMessage = false
    @State private var finishTimer: Timer?
    
    var body: some View {
        ZStack {
            // 🗺 Map + route
            Map(position: $viewModel.cameraPosition) {
                if !viewModel.route.isEmpty {
                    MapPolyline(coordinates: viewModel.route)
                        .stroke(.orange, lineWidth: 5)
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    viewModel.recenter()
                } label: {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.top, 60)
                .padding(.trailing, 20)
            }
            .overlay(alignment: .topLeading) {
                VStack(spacing: 16) {
                    Button {
                        showHistory = true
                    } label: {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .font(.title2)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .foregroundColor(.primary)
                    }
                    
                    if viewModel.runState == .idle {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.top, 60)
                .padding(.leading, 20)
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            
            VStack {
                Spacer()
                
                // STATS PANEL
                if viewModel.runState != .idle {
                    VStack(spacing: 20) {
                        // Top row: TIME
                        VStack(spacing: 4) {
                            Text("TIME")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(viewModel.formatTime(viewModel.elapsedTime))
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                        }
                        
                        // Bottom row: DISTANCE and PACE
                        HStack(spacing: 40) {
                            VStack(spacing: 4) {
                                Text("DISTANCE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                Text(String(format: "%.2f km", viewModel.totalDistance() / 1000))
                                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                            }
                            
                            VStack(spacing: 4) {
                                Text("AVG PACE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                Text("\(viewModel.averagePace())")
                                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                            }
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                
                // CONTROLS
                HStack(spacing: 30) {
                    if viewModel.runState == .idle {
                        Button(action: {
                            viewModel.startTracking()
                        }) {
                            Text("START")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    } else if viewModel.runState == .running {
                        Button(action: {
                            viewModel.pauseTracking()
                        }) {
                            Image(systemName: "pause.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    } else if viewModel.runState == .paused {
                        Button(action: {
                            viewModel.resumeTracking()
                        }) {
                            Text("RESUME")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            viewModel.finishTracking(context: modelContext)
                            showFinishMessage = true
                            // Auto-dismiss after 2 seconds
                            finishTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                                dismiss()
                            }
                        }) {
                            Text("FINISH")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.black)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            
            // Success message
            if showFinishMessage {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    VStack(spacing: 4) {
                        Text("Run Saved!")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Your run has been added to history")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            finishTimer?.invalidate()
                            dismiss()
                        }) {
                            Text("Back Home")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showHistory = true
                        }) {
                            Text("View History")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(32)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
        .sheet(isPresented: $showHistory) {
            HistoryView()
        }
    }
}

#Preview{
    MapView()
}
