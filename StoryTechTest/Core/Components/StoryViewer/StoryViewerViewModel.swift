//
//  StoryViewerViewModel.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import Factory
import SwiftfulRouting

@Observable
class StoryViewerViewModel {
    var currentIndex: Int = 0
    var progress: CGFloat {
        currentStory?.isSeen == true ? 1 : 0
    }
    var currentUserStories: [Story] = []
    var currentStoryUrl: String? {
        return currentStory?.url
    }
    var currentStoryIsLiked: Bool {
        return currentStory?.isLiked ?? false
    }

    enum Constants {
        static let storyDuration: TimeInterval = 5.0
    }

    private var currentStory: Story? {
        didSet {
            if let currentStory, !currentStory.isSeen {
                setCurrentStoryAsSeen(story: currentStory)
            }
        }
    }
    private var progressValue: CGFloat = 0
    private var timer: Timer?
    private var startDate: Date?
    private var pausedProgress: CGFloat = 0
    private var isPaused: Bool = false
    private let userId: Int
    private let storyService: StoriesServiceProtocol
    private let router: StoryRouter

    init(userId: Int, router: StoryRouter, storyService: StoriesServiceProtocol = Container.shared.storiesService()) {
        self.storyService = storyService
        self.userId = userId
        self.router = router
    }
    
    func currentProgressForIndex(story: Story) -> CGFloat {
        let isBeforeCurrentStory = currentUserStories.firstIndex(where: { $0.id == story.id }) ?? 0 < currentIndex
        return story == currentStory ? progressValue : isBeforeCurrentStory ? 1 : 0
    }
    
    func loadedImage() {
        Task {
            await startTimer()
        }
    }
    
    func errorLoadingImage() {
        // TODO: - Handle Error
    }
    
    func getUserStories() async {
        do {
            guard let user = try await storyService.fetchUserStory(userId: userId), !user.stories.isEmpty else {
                goToNextUserStories()
                return
            }
            self.currentUserStories = user.stories
            self.currentStory = user.stories[safe: 0]
        } catch {
            print("Error fetching user stories: \(error)")
        }
    }

    func setCurrentStoryAsLiked() {
        Task {
            do {
                guard let story = currentStory else { return }
                try await storyService.toggleLike(userId: userId, storyId: story.id)
                if let index = currentUserStories.firstIndex(where: { $0.id == story.id }) {
                    currentStory?.isLiked.toggle()
                    currentUserStories[safe: index]?.isLiked.toggle()
                }
            } catch {
                print("Error liking story: \(error)")
            }
        }
    }
    
    func startTimer() async {
        timer?.invalidate()
        startDate = Date()
        isPaused = false

        await MainActor.run {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [updateProgress] _ in
                updateProgress()
            }
        }
    }
    
    func pauseTimer() {
        guard !isPaused else { return }
        isPaused = true
        timer?.invalidate()
        pausedProgress = progress
    }
    
    func resumeTimer() {
        guard isPaused else { return }
        isPaused = false
        startDate = Date()
        Task {
            await startTimer()
        }
    }
    
    func goToNextStory() {
        progressValue = 0
        timer?.invalidate()
        pausedProgress = 0
        
        if currentIndex < currentUserStories.count - 1 {
            currentIndex += 1
            currentStory = currentUserStories[safe: currentIndex]
        } else {
            goToNextUserStories()
        }
    }
    
    func goToPreviousStory() {
        timer?.invalidate()
        if currentIndex > 0 {
            progressValue = 0
            currentIndex -= 1
            currentStory = currentUserStories[safe: currentIndex]
            pausedProgress = 0
            progressValue = 0
            Task {
                await startTimer()
            }
        } else {
            Task {
                await startTimer()
            }
        }
    }
    
    func dismissStory() {
        timer?.invalidate()
        Task { @MainActor in
            router.dismissScreen()
        }
    }
    
    private func goToNextUserStories() {
        Task {
            guard let nextUserId = try? await storyService.getNextUserId(from: userId) else {
                dismissStory()
                return
            }
            await router.showUserStory(userId: nextUserId, option: .push)
        }
    }
    
    private func setCurrentStoryAsSeen(story: Story) {
        Task {
            do {
                try await storyService.setStorySeen(userId: userId, storyId: story.id)
                if let index = currentUserStories.firstIndex(where: { $0.id == story.id }) {
                    currentStory?.isSeen = true
                    currentUserStories[safe: index]?.isSeen = true
                }
            } catch {
                print("Error setting story as seen: \(error)")
            }
        }
    }
    
    private func updateProgress() {
        guard let start = startDate else { return }
        let elapsed = Date().timeIntervalSince(start)
        var progress = pausedProgress + CGFloat(elapsed / Constants.storyDuration)
        progress = min(progress, 1.0)
        progressValue = progress

        if progress >= 1.0 && currentStory?.isSeen == true {
            goToNextStory()
        }
    }
}
