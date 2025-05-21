//
//  StoryBubble.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct StoryBubble: View {

    @State var viewModel: StoryBubbleViewModel
    @State private var isPresenting: Bool = false

    var body: some View {
        VStack {
            ImageLoaderView(urlString: viewModel.user.avatar)
                .frame(width: 60, height: 60)
                .cornerRadius(60)
                .overlay(
                    Circle()
                        .stroke(LinearGradient(colors: [.purple, .red,.orange,.yellow], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5)
                        .frame(width: 68, height: 68)
                )
                .padding(6)
                .anyButton(.press) {
                    isPresenting = true
                }
                .fullScreenCover(isPresented: $isPresenting) {
                    #warning("TODO: Routing should not be in UI")
                    StoryViewer(viewModel: StoryViewerViewModel(userId: viewModel.user.id))
                }

            Text(viewModel.user.nickname)
                .font(.caption2)
                .foregroundColor(.primary)
        }
    }
}

struct StoryView: View {
    var body: some View {
        ImageLoaderView()
            .ignoresSafeArea()
    }
}
