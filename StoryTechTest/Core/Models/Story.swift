//
//  StoryUser.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import Foundation

struct StoryUser: Equatable, Identifiable {
    let id: Int
    let avatar: String
    let nickname: String
    var stories: [Story]
    
    init(dto: StoryUserDto) {
        self.id = dto.id
        self.avatar = dto.avatar
        self.nickname = dto.nickname
        self.stories = dto.stories.map { Story(dto: $0) }
    }
    
    init(entity: StoryUserEntity) {
        self.id = entity.id
        self.avatar = entity.avatar
        self.nickname = entity.nickname
        self.stories = entity.stories.map(Story.init)
    }
}

struct Story: Equatable, Identifiable {
    let id: Int
    let url: String
    var isLiked: Bool
    var isSeen: Bool
    
    init(dto: StoryDto) {
        self.id = dto.id
        self.url = dto.url
        self.isLiked = dto.isLiked
        self.isSeen = dto.isSeen
    }
    
    init(entity: StoryEntity) {
        self.id = entity.id
        self.url = entity.url
        self.isLiked = entity.isLiked
        self.isSeen = entity.isSeen
    }
}
