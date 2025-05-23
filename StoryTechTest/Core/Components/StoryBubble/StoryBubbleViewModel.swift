//
//  StoryBubbleViewModel.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import SwiftfulRouting

@Observable
class StoryBubbleViewModel {
    var user: StoryUser
    private let router: StoryRouter

    #warning("Should take story from storyService")
    init(user: StoryUser, router: StoryRouter) {
        self.user = user
        self.router = router
    }
    
    func goToStory() {
        Task {
            await router.showUserStory(userId: user.id, option: .fullScreenCover)
        }
    }
}
