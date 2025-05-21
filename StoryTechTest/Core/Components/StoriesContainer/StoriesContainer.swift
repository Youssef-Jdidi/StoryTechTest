//
//  StoriesContainer.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct StoriesContainer: View {
    @State private var viewModel: StoriesContainerViewModel
    
    init(viewModel: StoriesContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: DSSpacing.small.rawValue) {
                ForEach(viewModel.users, id: \ .id) { user in
                    StoryBubble(viewModel: StoryBubbleViewModel(user: user))
                        .onAppear {
                            if user == viewModel.users.last {
                                viewModel.shouldLoadNextPage = true
                            }
                        }
                }
                if viewModel.isLoadingPage {
                    ProgressView()
                        .frame(width: 40, height: 40)
                }
            }
            .padding([.horizontal, .top], DSSpacing.xsmall.rawValue)
        }
        .onAppear {
            viewModel.loadInitialAvatars()
        }
        .onChange(of: viewModel.shouldLoadNextPage) { _, shouldLoad in
            if shouldLoad {
                viewModel.loadNextPage()
            }
        }
    }
}
