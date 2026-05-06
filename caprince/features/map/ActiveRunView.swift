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
    var trainingDay: TrainingDay?
    
    @State private var timerManager = WorkoutTimerManager()
    @State private var currentFrame = 1
    @State private var spriteTimer: Timer? = nil
    @State private var showRestartConfirm = false
    @State private var showFinishConfirm = false
    
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
            
            if viewModel.isMaximized {
                // MARK: - Full Maximized View
                maximizedView
            } else {
                // MARK: - Minimized: map label + bottom card
                VStack(spacing: 0) {
                    // Activity label pill
                    Text(trainingDay != nil ? (timerManager.currentStep?.activity.rawValue.uppercased() ?? (timerManager.isFinished ? "COMPLETE" : "GET READY")) : viewModel.currentActivity)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(trainingDay != nil && timerManager.currentStep?.activity == .run ? Color("Brown-500") : Color("green-400"))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Capsule())
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    
                    Spacer()
                    
                    // Bottom minimized card
                    minimizedCard
                }
            }
        }
        .animation(.spring(), value: viewModel.isMaximized)
        .animation(.easeInOut, value: viewModel.sessionState)
        .onAppear {
            if let day = trainingDay {
                timerManager.loadSteps(day.steps)
            }
        }
        .onChange(of: viewModel.sessionState) { _, newState in
            if trainingDay != nil {
                switch newState {
                case .running:
                    timerManager.start()
                case .paused:
                    timerManager.pause()
                case .finished, .idle:
                    timerManager.stop()
                }
            }
        }
        .onChange(of: timerManager.isFinished) { _, isFinished in
            if isFinished && viewModel.sessionState == .running {
                viewModel.stopSession()
            }
        }
    }
    
    
    // MARK: - Full Maximized View
    private var maximizedView: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header row
                ZStack {
                    Text(trainingDay != nil
                         ? (timerManager.currentStep?.activity.rawValue.capitalized ?? (timerManager.isFinished ? "Complete" : "Get Ready"))
                         : "Running")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                viewModel.isMaximized = false
                            }
                        }) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .rotationEffect(.degrees(90))
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color(UIColor.systemGray6))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                // Timer + stats + capybara
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Interval Timer
                        if trainingDay != nil {
                            Text(timerManager.formattedTime)
                                .font(.system(size: 80, weight: .bold, design: .rounded))
                                .foregroundColor((timerManager.currentStep?.activity == .run) ? Color("Brown-500") : Color("green-400"))
                                .padding(.top, 24)
                            
                            Text("Interval Time Remaining")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.5))
                                .padding(.top, 4)
                            
                            HStack(spacing: 4) {
                                Text("Total Time:")
                                    .font(.system(size: 14)).foregroundColor(.black.opacity(0.5))
                                Text(viewModel.formattedTime)
                                    .font(.system(size: 14, weight: .bold)).foregroundColor(.black)
                            }
                            .padding(.top, 12)
                        } else {
                            Text(viewModel.formattedTime)
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundColor(Color("Brown-500"))
                                .padding(.top, 24)
                        }
                        
                        // Capybara animation
                        ZStack {
                            Image("garden")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .clipped()
                                .offset(y: 40)
                            
                            Image("capybara_img\(currentFrame)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .onAppear { startSpriteAnimation() }
                                .onChange(of: viewModel.isMaximized) {
                                    if viewModel.isMaximized { startSpriteAnimation() }
                                    else { stopSpriteAnimation() }
                                }
                        }
                        .padding(.top, 24)
                        .frame(height: 130)
                        
                        // Avg Pace
                        Text(viewModel.formattedPace)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.top, 36)
                        Text("Avg. pace(/km)")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Brown-500"))
                            .padding(.top, 2)
                        
                        // Distance
                        Text(String(format: "%.2f", viewModel.distance).replacingOccurrences(of: ".", with: ","))
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.top, 24)
                        Text("Distance (km)")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Brown-500"))
                            .padding(.top, 2)
                        
                        // Controls
                        if viewModel.sessionState == .idle {
                            Button(action: { viewModel.startSession() }) {
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color("Brown-500"))
                                    .clipShape(Circle())
                            }
                            .padding(.top, 36)
                        } else {
                            HStack(spacing: 28) {
                                // Pause / Resume
                                if viewModel.sessionState == .running {
                                    Button(action: { viewModel.pauseSession() }) {
                                        Image(systemName: "pause.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 72, height: 72)
                                            .background(Color(red: 0.28, green: 0.20, blue: 0.13))
                                            .clipShape(Circle())
                                    }
                                } else {
                                    Button(action: { viewModel.resumeSession() }) {
                                        Image(systemName: "play.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 72, height: 72)
                                            .background(Color(red: 0.28, green: 0.20, blue: 0.13))
                                            .clipShape(Circle())
                                    }
                                }
                                
                                // Stop → Finish confirm
                                Button(action: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        showFinishConfirm = true
                                    }
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 72, height: 72)
                                        .background(Color(red: 0.94, green: 0.27, blue: 0.27))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.top, 36)
                        }
                        
                        Spacer().frame(height: 48)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            // MARK: - Confirmation Overlays
            if showRestartConfirm || showFinishConfirm {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showRestartConfirm = false
                            showFinishConfirm = false
                        }
                    }
            }
            
            if showRestartConfirm {
                confirmationCard(
                    title: "Restart workout?",
                    message: "Are you sure you want to restart?",
                    actionLabel: "Restart",
                    action: {
                        showRestartConfirm = false
                        viewModel.resetSession()
                    },
                    cancel: { showRestartConfirm = false }
                )
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            
            if showFinishConfirm {
                confirmationCard(
                    title: "Finish workout?",
                    message: "Are you sure you want to end your run?",
                    actionLabel: "Finish",
                    action: {
                        showFinishConfirm = false
                        viewModel.stopSession()
                    },
                    cancel: { showFinishConfirm = false }
                )
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showRestartConfirm)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showFinishConfirm)
    }
    
    // MARK: - Confirmation Pop-out Card (Figma spec)
    private func confirmationCard(
        title: String,
        message: String,
        actionLabel: String,
        action: @escaping () -> Void,
        cancel: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 12) {
                // Cancel
                Button(action: { withAnimation { cancel() } }) {
                    Text("Cancel")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Capsule())
                }
                
                // Action
                Button(action: { withAnimation { action() } }) {
                    Text(actionLabel)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.40, green: 0.28, blue: 0.16))
                        .clipShape(Capsule())
                }
            }
            .padding(.top, 4)
        }
        .padding(14)
        .frame(width: 300, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
    }
    
    // MARK: - Minimized Card (Figma Design)
    private var minimizedCard: some View {
        VStack(spacing: 0) {
            // Expand arrow
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        viewModel.isMaximized.toggle()
                    }
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Stats Row
            HStack(spacing: 0) {
                // Avg. Pace
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.formattedPace)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text("Avg. pace(/km)")
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Interval (only if training day)
                if trainingDay != nil {
                    VStack(alignment: .center, spacing: 4) {
                        Text(timerManager.formattedTime)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.72, green: 0.45, blue: 0.20))
                        Text("Interval")
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Distance
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.2f", viewModel.distance).replacingOccurrences(of: ".", with: ","))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text("Distance (Km)")
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 24)
            .padding(.top, 4)
            
            // Controls
            if viewModel.sessionState == .idle {
                HStack {
                    Spacer()
                    Button(action: { viewModel.startSession() }) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 68, height: 68)
                            .background(Color("Brown-500"))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
            } else {
                HStack(spacing: 24) {
                    Spacer()
                    
                    // Pause / Resume button
                    if viewModel.sessionState == .running {
                        Button(action: { viewModel.pauseSession() }) {
                            Image(systemName: "pause.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 68, height: 68)
                                .background(Color(red: 0.28, green: 0.20, blue: 0.13))
                                .clipShape(Circle())
                        }
                    } else {
                        Button(action: { viewModel.resumeSession() }) {
                            Image(systemName: "play.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 68, height: 68)
                                .background(Color(red: 0.28, green: 0.20, blue: 0.13))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Stop button
                    Button(action: { viewModel.stopSession() }) {
                        Image(systemName: "stop.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 68, height: 68)
                            .background(Color(red: 0.94, green: 0.27, blue: 0.27))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(width: 371)
        .background(Color(red: 1, green: 1, blue: 0.98))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: -4)
        .padding(.bottom, 16)
    }
    
    // MARK: - Maximized Controls (appended below the full-screen content)
    private var maximizedControls: some View {
        VStack(spacing: 20) {
            // Controls
            if viewModel.sessionState == .idle {
                HStack {
                    Spacer()
                    Button(action: { viewModel.startSession() }) {
                        Image(systemName: "play.fill")
                            .font(.largeTitle).foregroundColor(.white)
                            .frame(width: 80, height: 80).background(Color("Brown-500")).clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.vertical, 10)
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
                    } else {
                        ControlButtonView(icon: "play.fill", color: Color("green-400")) {
                            viewModel.resumeSession()
                        }
                    }
                    
                    ControlButtonView(icon: "stop.fill", color: Color("green-200")) {
                        viewModel.stopSession()
                    }
                    Spacer()
                }
                .padding(.vertical, 10)
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
    ActiveRunView(viewModel: RunTrackerViewModel(), trainingDay: nil)
}
