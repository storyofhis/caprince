//
//  ActiveRunView.swift
//  caprince
//
//  Created by Bernardus William Santosa on 03/05/26.
//

import SwiftUI
import MapKit

struct ActiveRunView: View {
    @ObservedObject var viewModel: RunTrackerViewModel
    @State private var currentFrame = 1
    @State private var spriteTimer: Timer? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Layer
            if viewModel.isMaximized {
                Color(.white).ignoresSafeArea()
            } else {
                MapComponent(coordinates: $viewModel.coordinates, cameraPosition: $viewModel.cameraPosition)
                    .ignoresSafeArea()
                
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                viewModel.cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
                            }
                        }) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding(8)
                                .contentShape(Circle())
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                        }
                        .zIndex(1)
                        .padding(.trailing, 30)
                        .padding(.bottom, 250)
                    }
            }
            
            VStack(spacing: 0) { // 👈 Tambahkan spacing 0
                // 1. HEADER
                ZStack {
                    // Teks di tengah persis
                    Text(viewModel.currentActivity)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Capsule())
                    
                    // Tombol minimize
                    if viewModel.isMaximized {
                        HStack {
                            Spacer()
                            Button(action: { viewModel.isMaximized.toggle() }) {
                                Image(systemName: "arrow.up.right.and.arrow.down.left")
                                    .foregroundColor(.black)
                                    .padding(6)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
                .padding(.top, 15) // 👈 Jarak aman teks dari poni
                .padding(.bottom, 15)
                .background(
                    // 👈 Warnanya ditarik sampai ke poni layar!
                    (viewModel.isMaximized ? Color("Brown-300") : Color.clear)
                        .ignoresSafeArea(edges: .top)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        viewModel.isMaximized.toggle()
                    }
                }
                
                // MAXMIZED CONTENT
                if viewModel.isMaximized {
                    VStack {
                        Spacer()
                        
                        Text(viewModel.formattedTime)
                            .font(.system(size: 60)).foregroundColor(.black)
                            .padding(.horizontal, 30)
                        
                        ZStack { // animasi capy
                            //LAPISAN BG
                            Image("garden")
                                .resizable()
                                .scaledToFill()
                                .frame(width: .infinity, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .offset(y: 40)
                            
                            //LAPISAN DEPAN (Capybara)
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
                        }
                        
                        Text(viewModel.formattedPace)
                            .font(.system(size: 60)).foregroundColor(.black)
                            .padding(.horizontal, 30).padding(.top, 15)
                        Text("Avg.pace(/km)")
                            .font(.system(size: 20)).foregroundColor(.black)
                        
                        Text(String(format: "%.2f", viewModel.distance))
                            .font(.system(size: 60)).foregroundColor(.black)
                            .padding(.horizontal, 30).padding(.top, 15)
                        Text("Distance (km)")
                            .font(.system(size: 20)).foregroundColor(.black)
                        
                        Spacer()
                    }
                    .transition(.opacity)
                    .frame(maxHeight: .infinity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.isMaximized.toggle()
                        }
                    }
                } 
                
                // DASHBOARD BAWAH
                dashboardCard
            }
        }
        .animation(.spring(), value: viewModel.isMaximized)
        .animation(.easeInOut, value: viewModel.sessionState)
    }
    
    
    //kotak stats
    private var dashboardCard: some View {
        VStack(spacing: 20) {
            //Minimize/Maximize Button
            if !viewModel.isMaximized{
                HStack {
                    Spacer()
                    Button(action: { viewModel.isMaximized.toggle() }) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
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
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: -8)
                
            }
            
            
            
            // Stats
            HStack{
                if !viewModel.isMaximized {
                    StatView(title: "Time", value: viewModel.formattedTime)
                    StatView(title: "Avg. pace(/km)", value: viewModel.formattedPace)
                    StatView(title: "Distance (km)", value: String(format: "%.2f", viewModel.distance))
                }
            }
            
            
            // Controls
            if viewModel.sessionState == .idle {
                HStack{
                    Spacer()
                    Button(action: { viewModel.startSession() }) {
                        Image(systemName: "play.fill")
                            .font(.largeTitle).foregroundColor(.white)
                            .frame(width: 80, height: 80).background(Color("Brown-500")).clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.top, 10)
            } else {
                HStack(spacing: 30) {
                    Spacer()
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
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                viewModel.isMaximized.toggle()
            }
        }
        .background(.white)
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
