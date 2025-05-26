//
//  StoryBubble.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import SwiftfulRouting

struct StoryBubble: View {

    @State var viewModel: StoryBubbleViewModel

    var body: some View {
        VStack {
            ImageLoaderView(urlString: viewModel.user.avatar)
                .frame(width: 60, height: 60)
                .cornerRadius(60)
                .ifElseSatisfiedCondition(viewModel.isSeen,
                                          ifTransform: { content in
                    content
                        .overlay(
                            Circle()
                                .stroke(.gray, lineWidth: 2.5)
                                .frame(width: 68, height: 68)
                        )
                },
                                          elseTransform: { content in
                    content
                        .overlay(
                            Circle()
                                .stroke(LinearGradient(colors: [.purple, .red,.orange,.yellow], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5)
                                .frame(width: 68, height: 68)
                        )
                })
                .padding(6)
                .anyButton(.press) {
                    viewModel.goToStory()
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
