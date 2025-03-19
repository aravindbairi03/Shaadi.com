//
//  Shaadi_comApp.swift
//  Shaadi.com
//

import SwiftUI
import SwiftData

@main
struct Shaadi_comApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MatchDetailsEntity.self)
    }
}
