//
//  ContentView.swift
//  Shaadi.com
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ProfileMatchesView(modelContext: modelContext)
    }
}

//#Preview {
//    ContentView()
//}
