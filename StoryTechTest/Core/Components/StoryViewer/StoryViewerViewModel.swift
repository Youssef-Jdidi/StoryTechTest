//
//  StoryViewerViewModel.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import Factory

@Observable
class StoryViewerViewModel {
    var currentUserStories: [Story] = []
    var currentIndex: Int = 0
    var shouldDismiss: Bool = false
    
    enum Constants {
        static let storyDuration: TimeInterval = 5.0
    }

    private var allUsersStories: [StoryUserDto] = []
    private var timer: Timer?
    private var startDate: Date?
    private var pausedProgress: CGFloat = 0
    private var isPaused: Bool = false
    private var userId: Int = 0
    private let storyService: StoriesServiceProtocol

    init(userId: Int, storyService: StoriesServiceProtocol = Container.shared.storiesService()) {
        self.storyService = storyService
        self.userId = userId
    }
    
    private func setCurrentStoryAsSeen() {
        Task {
            guard var currentStory = currentUserStories[safe: currentIndex] else { return }
            currentStory.isSeen = true
            currentUserStories[safe: currentIndex] = currentStory
            await storyService.setStorySeen(userId: userId, storyId: currentStory.id)
        }
    }
    
    func setCurrentStoryAsLiked() {
        Task {
            guard var currentStory = currentUserStories[safe: currentIndex] else { return }
            currentStory.isLiked.toggle()
            currentUserStories[safe: currentIndex] = currentStory
            await storyService.toggleLike(userId: userId, storyId: currentStory.id)
        }
    }
    func onAppear() {
        Task {
            allUsersStories = await storyService.getUsersStories()
            #warning("TODO: map to Domain entity shouldn't be in VM")
            currentUserStories = allUsersStories.first(where: { $0.id == userId })?.stories.map({
                Story(id: $0.id, url: $0.url, isLiked: $0.isLiked, isSeen: $0.isSeen)
            }) ?? []
            startTimer()
            setCurrentStoryAsSeen()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        startDate = Date()
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    func pauseTimer() {
        guard !isPaused else { return }
        isPaused = true
        timer?.invalidate()
        pausedProgress = currentUserStories[safe: currentIndex]?.progress ?? 0
    }
    
    func resumeTimer() {
        guard isPaused else { return }
        isPaused = false
        startDate = Date()
        startTimer()
    }
    
    private func updateProgress() {
        guard let start = startDate else { return }
        
        let elapsed = Date().timeIntervalSince(start)
        var progress = pausedProgress + CGFloat(elapsed / Constants.storyDuration)
        progress = min(progress, 1.0)
        currentUserStories[safe: currentIndex]?.progress = progress

        if progress >= 1.0 {
            goToNextStory()
        }
    }
    
    func goToNextStory() {
        currentUserStories[safe: currentIndex]?.progress = 1
        timer?.invalidate()
        pausedProgress = 0
        
        if currentIndex < currentUserStories.count - 1 {
            currentIndex += 1
            startTimer()
        } else {
            #warning("TODO: go to next user stories or dismiss if no more stories")
            shouldDismiss = true
        }
    }
    
    func goToPreviousStory() {
        timer?.invalidate()
        if currentIndex > 0 {
            currentUserStories[safe: currentIndex]?.progress = 0
            currentIndex -= 1
            pausedProgress = 0
            currentUserStories[safe: currentIndex]?.progress = 0
            startTimer()
        } else {
            startTimer()
        }
    }
    
    func onDisappear() {
        timer?.invalidate()
    }
}
