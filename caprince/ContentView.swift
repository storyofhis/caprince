//
//  ContentView.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: caprinceDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(caprinceDocument()))
}
