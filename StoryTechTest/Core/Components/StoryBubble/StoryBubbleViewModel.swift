//
//  StoryBubbleViewModel.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

@Observable
class StoryBubbleViewModel {
    var user: StoryUserDto

    #warning("Should take story from storyService")
    init(user: StoryUserDto) {
        self.user = user
    }
}
