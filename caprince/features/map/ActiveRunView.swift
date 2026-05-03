//
//  ActiveRunView.swift
//  caprince
//
//  Created by Bernardus William Santosa on 03/05/26.
//

import SwiftUI

struct ActiveRunView: View {
    @ObservedObject var viewModel: RunTrackerViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Layer
            if viewModel.isMaximized {
                Color("Brown-100").ignoresSafeArea()
            } else {
                MapComponent(coordinates: $viewModel.coordinates, cameraPosition: $viewModel.cameraPosition)
                    .ignoresSafeArea()
            }
            
            VStack {
                // Header
                HStack {
                    Button(action: { /* Back Action */ }) {
                        Image(systemName: "chevron.left")
                            .padding(12).background(Color.white).clipShape(Circle()).shadow(radius: 3)
                    }
                    Spacer()
                    Text(viewModel.currentActivity)
                        .font(.subheadline).fontWeight(.semibold)
                        .padding(.horizontal, 20).padding(.vertical, 10)
                        .background(Color.white.opacity(0.9)).clipShape(Capsule())
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal).padding(.top, 10)
                
                Spacer()
                
                // Capybara Screen (Maximized)
                if viewModel.isMaximized {
                    VStack {
                        Text(viewModel.formattedTime)
                            .font(.system(size: 50, weight: .bold)).foregroundColor(.white)
                            .padding(.horizontal, 30).padding(.vertical, 15)
                            .background(Color(red: 0.45, green: 0.35, blue: 0.25)).cornerRadius(20)
                            .padding(.bottom, 20)
                        
                        Image("capybara_img")
                            .resizable().scaledToFit().frame(height: 150).padding(.bottom, 40)
                    }
                    .transition(.opacity)
                }
                
                // Dashboard Card
                dashboardCard
            }
        }
        .animation(.spring(), value: viewModel.isMaximized)
        .animation(.easeInOut, value: viewModel.sessionState)
    }
    
    // Sub-view: Kotak Kontrol Bawah
    private var dashboardCard: some View {
        VStack(spacing: 20) {
            // Minimize/Maximize Button
            HStack {
                Spacer()
                Button(action: { viewModel.isMaximized.toggle() }) {
                    Image(systemName: viewModel.isMaximized ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .padding(10).background(Color.gray.opacity(0.15)).clipShape(Circle()).foregroundColor(.black)
                }
            }
            
            // Stats
            HStack(spacing: viewModel.isMaximized ? 50 : 30) {
                if !viewModel.isMaximized {
                    StatView(title: "Time", value: viewModel.formattedTime)
                }
                StatView(title: "Avg. pace(/km)", value: viewModel.formattedPace)
                StatView(title: "Distance (km)", value: String(format: "%.2f", viewModel.distance))
            }
            
            // Controls
            if viewModel.sessionState == .idle {
                Button(action: { viewModel.startSession() }) {
                    Image(systemName: "play.fill")
                        .font(.largeTitle).foregroundColor(.white)
                        .frame(width: 80, height: 80).background(Color(red: 0.45, green: 0.35, blue: 0.25)).clipShape(Circle())
                }
                .padding(.top, 10)
            } else {
                HStack(spacing: 30) {
                    ControlButtonView(icon: "arrow.counterclockwise", color: Color("Brown-300")) {
                        viewModel.resetSession()
                    }
                    
                    if viewModel.sessionState == .running {
                        ControlButtonView(icon: "pause.fill", color: Color("Brown-500")) {
                            viewModel.pauseSession()
                        }
                    } else { // Jika dipause
                        ControlButtonView(icon: "play.fill", color: Color("green-400")) {
                            viewModel.resumeSession()
                        }
                    }
                    
                    ControlButtonView(icon: "stop.fill", color: Color("green-200")) {
                        viewModel.stopSession()
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(24).background(Color.white).cornerRadius(30)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10)
        .padding(.horizontal, 16).padding(.bottom, 20)
    }
}
