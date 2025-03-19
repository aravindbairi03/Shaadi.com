//
//  MatchDetailsView.swift
//  Shaadi.com
//

import SwiftUI
import SDWebImageSwiftUI


// match card view
struct MatchDetailsView: View {
    var matchDetails: MatchDetailsEntity
    @State private var isAccpeted: Bool? = nil
    @ObservedObject var viewModel: MatchDetailsViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            WebImage(url: URL(string: matchDetails.largeImage))
                .resizable()
                .frame(width: 120, height: 120)
                .padding(10)
            
            Text(matchDetails.firstName + " " + matchDetails.lastName)
                .font(.system(size: 24, weight: .bold))
                .bold()
                .foregroundStyle(Color.appColor)
            
            Text("\(matchDetails.streetName), \(matchDetails.state)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
            
            ButtonsView(isAccpeted: $isAccpeted) {
                viewModel.handleMatchAction(uuid: matchDetails.uuid, isAccepted: $0)
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.white]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

/// If action is performed, it shows accpeted/rejected else both buttons
struct ButtonsView: View {
    @Binding var isAccpeted: Bool?
    var onAction: (Bool) -> Void
    
    var body: some View {
        if let state = isAccpeted {
            Text(state ? "Accepted" : "Rejected")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appColor)
                .cornerRadius(8)
        } else {
            HStack(spacing: 50) {
                Button(action: {
                    isAccpeted =  false
                    onAction(false)
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.gray)
                }
                .frame(width: 50, height: 50)
                .background(Circle().stroke(Color.appColor, lineWidth: 2))
                
                Button(action: {
                    isAccpeted = true
                    onAction(true)
                }) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.gray)
                }
                .frame(width: 50, height: 50)
                .background(Circle().stroke(Color.appColor, lineWidth: 2))
            }
            .padding(.bottom, 10)
        }
    }
}

//#Preview {
//    MatchDetailsView()
//}
