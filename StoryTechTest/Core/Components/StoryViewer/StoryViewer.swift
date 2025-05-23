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
        Group {
            if let url = viewModel.currentStoryUrl {
                content(url: url)
            } else {
                loaderView
            }
        }
        .task {
            await viewModel.getUserStories()
        }
        .navigationBarBackButtonHidden()
        .statusBarHidden(true)
    }
    
    private var loaderView: some View {
        ProgressView()
            .tint(.white)
    }
    
    private func content(url: String) -> some View {
        ZStack(alignment: .top) {
            ImageLoaderView(urlString: url,
                            onLoaded: viewModel.loadedImage,
                            onError: viewModel.errorLoadingImage)
            
            VStack {
                HStack(spacing: DSSpacing.xxxsmall.rawValue) {
                    ForEach(Array(viewModel.currentUserStories.enumerated()), id: \.element.id) { index, story in
                        // TODO: - Split to a separate view to control rebuild ( Split ViewModel )
                        ProgressView(value: viewModel.currentProgressForIndex(story: story))
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .frame(height: DSSpacing.xxsmall.rawValue)
                            .animation(index == viewModel.currentIndex ? .linear : .none, value: viewModel.progress)
                    }
                }
                .padding(.top, 56)
                .padding(.horizontal)
                HStack {
                    Image(systemName: viewModel.currentStoryIsLiked ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                        .anyButton {
                            viewModel.setCurrentStoryAsLiked()
                        }
                    Spacer()
                    Image(systemName: "xmark")
                        .anyButton {
                            viewModel.dismissStory()
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
}
