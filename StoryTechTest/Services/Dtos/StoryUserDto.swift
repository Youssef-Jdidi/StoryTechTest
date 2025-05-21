//
//  StoryUserDto.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//


struct StoryUserDto: Codable, Equatable, Identifiable {
    let id: Int
    let avatar: String
    let nickname: String
    var stories: [StoryDto]
}

struct StoryDto: Codable, Equatable, Identifiable {
    let id: Int
    let url: String
    var isLiked: Bool
    var isSeen: Bool
}