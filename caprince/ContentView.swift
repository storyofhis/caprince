//
//  ContentView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
    }
}

#Preview {
    ContentView()
}
