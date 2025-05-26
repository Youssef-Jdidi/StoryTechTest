//
//  StoryBubbleViewModel.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import SwiftfulRouting
import Factory

@Observable
class StoryBubbleViewModel {
    var isSeen: Bool {
        user.stories.allSatisfy { $0.isSeen }
    }
    var user: StoryUser
    private let router: StoryRouter
    private let storyService: StoriesServiceProtocol

    init(user: StoryUser, router: StoryRouter, storyService: StoriesServiceProtocol = Container.shared.storiesService()) {
        self.user = user
        self.router = router
        self.storyService = storyService
    }
    
    func goToStory() {
        Task { [weak self] in
            guard let self else { return }
            await router.showUserStory(userId: user.id, option: .fullScreenCover, onDisappear: refreshBubble)
        }
    }

    //TODO: Should be done to all stories and not only the story we came from
    @MainActor
    private func refreshBubble() {
        Task { @MainActor in
            let updatedUser = try await storyService.fetchUserStory(userId: user.id) ?? user
            self.user = updatedUser
        }
    }
}
