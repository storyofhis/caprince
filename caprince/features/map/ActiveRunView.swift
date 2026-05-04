//
//  ActiveRunView.swift
//  caprince
//
//  Created by Bernardus William Santosa on 03/05/26.
//

import SwiftUI

struct ActiveRunView: View {
    @ObservedObject var viewModel: RunTrackerViewModel
    @State private var currentFrame = 1
    @State private var spriteTimer: Timer? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Layer
            if viewModel.isMaximized {
                Color("Base-100").ignoresSafeArea()
            } else {
                MapComponent(coordinates: $viewModel.coordinates, cameraPosition: $viewModel.cameraPosition)
                    .ignoresSafeArea()
            }
            
            VStack {
                // Header
                HStack {
                    Button(action: { /* Back Action */ }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
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
                .padding(.horizontal)
                .padding(.top,70)
                //                .offset(y: -20)
                //                .ignoresSafeArea()
                
                
                Spacer()
                
                // Capybara Screen (Maximized)
                if viewModel.isMaximized {
                    VStack {
                        Text(viewModel.formattedTime)
                            .font(.system(size: 60)).foregroundColor(.white)
                            .bold()
                            .padding(.horizontal, 30).padding(.vertical, 10)
                            .background(Color("Brown-500")).cornerRadius(20)
                            .padding(.bottom,40)
                        
                        Image("capybara_img\(currentFrame)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .onAppear {
                                if viewModel.isMaximized { startSpriteAnimation() }
                            }
                            .onChange(of: viewModel.isMaximized) {
                                if viewModel.isMaximized {
                                    startSpriteAnimation()
                                } else {
                                    stopSpriteAnimation()
                                }
                            }
                        
                        Text(viewModel.formattedPace)
                            .font(.system(size: 30)).foregroundColor(.black)
                            .padding(.horizontal, 30).padding(.top, 15)
                            .bold()
                        Text("Avg.pace(/km)")
                            .font(.system(size: 20)).foregroundColor(.black)
                            .padding(.horizontal, 30)
                        
                        Text(String(format: "%.2f", viewModel.distance))
                            .font(.system(size: 30)).foregroundColor(.black)
                            .padding(.horizontal, 30).padding(.top, 15)
                            .bold()
                        Text("Distance (km)")
                            .font(.system(size: 20)).foregroundColor(.black)
                            .padding(.horizontal, 30).padding(.bottom,20)
                    }
                    .transition(.opacity)
                }
                
                dashboardCard
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    viewModel.isMaximized.toggle()
                }
            }
            .ignoresSafeArea(.container, edges: .top)
        }
        .animation(.spring(), value: viewModel.isMaximized)
        .animation(.easeInOut, value: viewModel.sessionState)
    }
    
    //kotak stats
    private var dashboardCard: some View {
        VStack(spacing: 20) {
            //Minimize/Maximize Button
            HStack {
                
                Spacer()
                Button(action: { viewModel.isMaximized.toggle() }) {
                    Image(systemName: viewModel.isMaximized ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.black)
                        .padding(6)
                }
            }
            
            .padding(13)
            .background(Color("Brown-300"))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 10,
                    topTrailingRadius: 10
                )
            )
            
            
            
            // Stats
            HStack(spacing: viewModel.isMaximized ? 50 : 30) {
                if !viewModel.isMaximized {
                    StatView(title: "Time", value: viewModel.formattedTime)
                    StatView(title: "Avg. pace(/km)", value: viewModel.formattedPace)
                    StatView(title: "Distance (km)", value: String(format: "%.2f", viewModel.distance))
                }
            }
            
            // Controls
            if viewModel.sessionState == .idle {
                Button(action: { viewModel.startSession() }) {
                    Image(systemName: "play.fill")
                        .font(.largeTitle).foregroundColor(.white)
                        .frame(width: 80, height: 80).background(Color("Brown-500")).clipShape(Circle())
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
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                viewModel.isMaximized.toggle()
            }
        }
        .background(Color.white)
    }
    
    private func startSpriteAnimation() {
        // Pastikan tidak ada timer yang sedang jalan sebelumnya
        stopSpriteAnimation()
        
        spriteTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            // Logika ganti frame 1 -> 2 -> 1
            currentFrame = (currentFrame == 1) ? 2 : 1
        }
    }

    private func stopSpriteAnimation() {
        spriteTimer?.invalidate()
        spriteTimer = nil
        currentFrame = 1 // Reset ke posisi berdiri normal saat mengecil
    }
}

#Preview {
    ActiveRunView(viewModel: RunTrackerViewModel())
}
