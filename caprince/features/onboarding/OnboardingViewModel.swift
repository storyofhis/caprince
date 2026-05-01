//
//  OnboardingViewModel.swift
//  caprince
//
//  Created by Clarawita on 01/05/26.
//

import SwiftUI

struct OnboardingViewModel: Identifiable {
    let id = UUID()
    let image: String
    let titleNormal: String
    let titleHighlight: String
    let description: String
    let isImageTop: Bool
}

let onboardingData: [OnboardingViewModel] = [
    OnboardingViewModel(image: "onboardingCapy1", titleNormal: "Meet Your New\n", titleHighlight: "Running Bestie!", description: "We believe fitness should be as chill as a capybara in a hot spring. No stress, just steady progress.", isImageTop: true),
    OnboardingViewModel(image: "onboardingCapy2", titleNormal: "Small Steps,\n", titleHighlight: "Big Strides.", description: "Our beginner-friendly 5K program blends walking and jogging to build your stamina.", isImageTop: false),
    OnboardingViewModel(image: "onboardingCapy3", titleNormal: "Ready to Start\n", titleHighlight: "Striding?", description: "Let's get moving! Enable notifications so your Capy-coach can remind you when it's time for a jog.", isImageTop: true)
]
