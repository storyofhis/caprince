//
//  FinishRunView.swift
//  caprince
//
//  Created by Bernardus William Santosa on 03/05/26.
//

import SwiftUI

struct FinishRunView: View {
    @ObservedObject var viewModel: RunTrackerViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Bagianatas: map
                MapComponent(coordinates: $viewModel.coordinates, cameraPosition: $viewModel.cameraPosition)
                    .frame(height: geometry.size.height * 0.45)
                    .overlay(alignment: .topLeading) {
                        Button(action: { viewModel.resetSession() }) {
                            Image(systemName: "chevron.left")
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .padding(.top, 50)
                                .padding(.leading, 20)
                        }
                    }
                
                // Bagianbwh: report
                VStack(spacing: 20) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 10)
                    
                    Text("Week 1 Day 1")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("COMPLETED")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("green-200"))
                    
                    //Banner capy
                    HStack {
                        Image("capybara_fin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Congrats! Your fastest 1 miles ever!")
                            .font(.footnote)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Brown-100"))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    //Stat rport
                    VStack(spacing: 25) {
                        HStack {
                            StatView(title: "Distance", value: String(format: "%.2f km", viewModel.distance))
                                .frame(maxWidth: .infinity)
                            StatView(title: "Avg Pace", value: "\(viewModel.formattedPace) /km")
                                .frame(maxWidth: .infinity)
                        }
                        HStack {
                            // Dummy calculation untuk steps dan calories, idealnya ambil dari HealthKit
                            StatView(title: "Steps", value: "\(Int(viewModel.distance * 1300))")
                                .frame(maxWidth: .infinity)
                            StatView(title: "Calories", value: "\(Int(viewModel.distance * 65)) kcal")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Button(action: { viewModel.resetSession() }) {
                        Text("Continue")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .offset(y: -20)
            }
        }
        .ignoresSafeArea()
    }
}

// dont know wht is dis hehe
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    let dummyViewModel = RunTrackerViewModel()
    dummyViewModel.distance = 5.24 // Contoh jarak 5 KM
    dummyViewModel.timeElapsed = 1800 // Contoh waktu 30 menit
    
    return FinishRunView(viewModel: dummyViewModel)
}



