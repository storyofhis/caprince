//
//  ContentView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            NavigationStack {
                mainPageView()
            }
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
