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
    var isSeen: Bool {
        user.stories.allSatisfy { $0.isSeen }
    }
    var user: StoryUser
    private let router: StoryRouter

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
