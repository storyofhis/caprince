//
//  OnboardingComponent.swift
//  caprince
//
//  Created by Clarawita on 01/05/26.
//
import SwiftUI

struct OnboardingComponent: View {
    let page: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            if page.isImageTop {
                imageView
                textView
            } else {
                textView
                imageView
            }
        }
        .padding(.horizontal, 30)
    }
    
    // Pecah komponen agar kode lebih rapi
    private var imageView: some View {
        Image(page.image)
            .resizable()
            .scaledToFit()
            .frame(height: 365)
            // Catatan: Jika background melengkung itu adalah bagian dari gambar,
            // biarkan seperti ini. Jika itu shape terpisah, Anda harus menambahkan ZStack di sini.
    }
    
    private var textView: some View {
        VStack(spacing: 20) {
            
            let titleString: AttributedString = {
                var combined = AttributedString(page.titleNormal + page.titleHighlight)
                
                combined.font = .system(size: 30, weight: .bold, design: .rounded)
                combined.foregroundColor = .black
                
                if let range = combined.range(of: page.titleHighlight) {
                    combined[range].foregroundColor = Color("Brown-300")
                }
                return combined
            }()
            
            Text(titleString)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
