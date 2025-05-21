//
//  StoryViewer.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct StoryViewer: View {

    @State private var viewModel: StoryViewerViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: StoryViewerViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {

        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if let story = viewModel.currentUserStories[safe: viewModel.currentIndex] {
                    ImageLoaderView(urlString: story.url)
                }

                VStack {
                    HStack(spacing: DSSpacing.xxxsmall.rawValue) {
                        ForEach(Array(viewModel.currentUserStories.enumerated()), id: \.element.id) { index, story in
                            ProgressView(value: story.progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                                .frame(height: DSSpacing.xxsmall.rawValue)
                                .animation(index == viewModel.currentIndex ? .linear : .none, value: story.progress)
                        }
                    }
                    .padding(.top, 56)
                    .padding(.horizontal)
                    HStack {
                        Image(systemName: viewModel.currentUserStories[safe: viewModel.currentIndex]?.isLiked ?? false ? "heart.fill" : "heart")
                            .anyButton {
                                viewModel.setCurrentStoryAsLiked()
                            }
                        Spacer()
                        Image(systemName: "xmark")
                            .anyButton {
                                dismiss()
                            }
                    }
                    .padding(.all, DSSpacing.medium.rawValue)
                }
            }
            .ignoresSafeArea()
            .storyGestures(
                onTapLeft: viewModel.goToPreviousStory,
                onTapRight: viewModel.goToNextStory,
                onPause: viewModel.pauseTimer,
                onResume: viewModel.resumeTimer
            )
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            #warning("TODO: should be handled by the view model")
            if newValue {
                dismiss()
            }
        }
    }
}
