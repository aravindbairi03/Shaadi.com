//
//  ProfileMatchesView.swift
//  Shaadi.com
//

import SwiftUI
import SwiftData

struct ProfileMatchesView: View {
    @StateObject private var viewModel: MatchDetailsViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MatchDetailsViewModel(
            dataManager: DataManager(),
            modelContext: modelContext
        ))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Profile Matches")
                .frame(maxWidth:.infinity, alignment: .leading)
                .font(Font.headline)
                .bold()
                .foregroundStyle(Color.black)
                .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(viewModel.matchDetails, id: \.firstName) { match in
                        MatchDetailsView(matchDetails: match, viewModel: viewModel)
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.getMatchDetails()
            }
        }
    }
}

//#Preview {
//    ProfileMatchesView()
//}
