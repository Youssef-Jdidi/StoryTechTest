//
//  UserEntity.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 22/05/2025.
//

import SwiftData

@Model
final class StoryUserEntity {
    @Attribute(.unique)
    var id: Int
    var avatar: String
    var nickname: String
    @Relationship(inverse: \StoryEntity.user)
    var stories: [StoryEntity]
    
    init(id: Int, avatar: String, nickname: String, stories: [StoryEntity]) {
        self.id = id
        self.avatar = avatar
        self.nickname = nickname
        self.stories = stories
    }
    
    init(user: StoryUserDto) {
        self.id = user.id
        self.avatar = user.avatar
        self.nickname = user.nickname
        self.stories = user.stories.map(StoryEntity.init)
    }
    
    init(user: StoryUser) {
        self.id = user.id
        self.avatar = user.avatar
        self.nickname = user.nickname
        self.stories = user.stories.map(StoryEntity.init)
    }
}

@Model
final class StoryEntity {
    @Attribute(.unique)
    var id: Int
    var url: String
    var isLiked: Bool
    var isSeen: Bool
    var user: StoryUserEntity?
    
    init(id: Int, url: String, isLiked: Bool, isSeen: Bool) {
        self.id = id
        self.url = url
        self.isLiked = isLiked
        self.isSeen = isSeen
    }
    
    init(story: StoryDto) {
        self.id = story.id
        self.url = story.url
        self.isLiked = story.isLiked
        self.isSeen = story.isSeen
    }
    
    init(story: Story) {
        self.id = story.id
        self.url = story.url
        self.isLiked = story.isLiked
        self.isSeen = story.isSeen
    }
}
