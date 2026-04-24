//
//  caprinceApp.swift
//  caprince
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import SwiftUI

@main
struct caprinceApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: caprinceDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
