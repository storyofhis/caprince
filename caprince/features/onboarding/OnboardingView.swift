//
//  OnboardingView.swift
//  caprince
//
//  Created by Clarawita on 01/05/26.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // Background utama
            
            VStack {
                // 1. Swiping Content
                TabView(selection: $currentIndex) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingComponent(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Sembunyikan titik bawaan Apple
                .animation(.easeInOut, value: currentIndex)
                
                // 2. Custom Bottom Navigation
                bottomNavigationBar
            }
        }
    }
    
    private var bottomNavigationBar: some View {
        HStack {
            // Custom Page Indicator
            HStack(spacing: 8) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color("BrownHighlightColor") : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            
            Spacer()
            
            // Custom Next Button
            Button(action: {
                if currentIndex < onboardingData.count - 1 {
                    currentIndex += 1
                } else {
                    // Action ketika selesai onboarding (masuk ke halaman utama)
                    print("Selesai onboarding!")
                }
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        Image("arrowRight")
                    )
            }
        }
        .padding(.leading, 40)
//        .padding(.bottom, 20)
    }
}

#Preview {
    OnboardingView()
}
