//
//  StoriesService.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import Foundation
import Factory

extension Container {
    var storiesService: Factory<StoriesServiceProtocol> {
        self { StoriesService() }.cached
    }
}

protocol StoriesServiceProtocol {
    func fetchUsersStories(pageSize: Int, page: Int) async throws -> [StoryUserDto]
    func getUsersStories() async -> [StoryUserDto]
    func setStorySeen(userId: Int, storyId: Int) async
    func toggleLike(userId: Int, storyId: Int) async
}

actor StoriesService: StoriesServiceProtocol {
    private let networkingManager: NetworkingProtocol
    private var userStories: [StoryUserDto] = []

    init(networkingManager: NetworkingProtocol = Container.shared.networkingManager(.local)) {
        self.networkingManager = networkingManager
    }
    
    func fetchUsersStories(pageSize: Int, page: Int) async throws -> [StoryUserDto] {
        let results: [StoryUserDto] = try await networkingManager.fetchData(from: .fetchStories)
        self.userStories = Array(results.prefix(pageSize * page)) // Mock Pagination
        return self.userStories
    }
    
    func getUsersStories() async -> [StoryUserDto] {
        userStories
    }
    
    func setStorySeen(userId: Int, storyId: Int) async {}
    
    func toggleLike(userId: Int, storyId: Int) async {}
}
