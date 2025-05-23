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
    
    var userEntityDataSource: Factory<any SwiftDataPersistenceProtocol> {
        self { StoriesDataPersistence() }.cached
    }
}

protocol StoriesServiceProtocol {
    func fetchUsersStories(pageSize: Int, page: Int) async throws -> [StoryUser]
    func fetchUserStory(userId: Int) async throws -> StoryUser?
    func getStory(storyId: Int) async throws -> Story?
    func getNextUserId(from userId: Int) async throws -> Int?
    func setStorySeen(userId: Int, storyId: Int) async throws
    func toggleLike(userId: Int, storyId: Int) async throws
}

actor StoriesService: StoriesServiceProtocol {
    private let networkingManager: NetworkingProtocol
    private let userEntityDataSource: any SwiftDataPersistenceProtocol
    private var userStories: [StoryUser] = []

    init(networkingManager: NetworkingProtocol = Container.shared.networkingManager(.local),
         userEntityDataSource: any SwiftDataPersistenceProtocol = Container.shared.userEntityDataSource()) {
        self.networkingManager = networkingManager
        self.userEntityDataSource = userEntityDataSource
    }
    
    func fetchUsersStories(pageSize: Int, page: Int) async throws -> [StoryUser] {
        try? await Task.sleep(nanoseconds: 500_000_000)
        self.userStories = try await userEntityDataSource.getAll(pageSize: pageSize, offset: page)
        return userStories
    }
    
    func fetchUserStory(userId: Int) async throws -> StoryUser? {
        try? await Task.sleep(nanoseconds: 500_000_000)
        let user = try await userEntityDataSource.getById(userId)
        return user
    }
    
    func getNextUserId(from userId: Int) async throws -> Int? {
        guard let userIdIndex = userStories.firstIndex(where: { $0.id == userId }) else {
            return nil
        }
        return userStories[safe: userIdIndex + 1]?.id
    }

    func getStory(storyId: Int) async throws -> Story? {
        try await userEntityDataSource.getStoryById(storyId)
    }
    
    func setStorySeen(userId: Int, storyId: Int) async throws {
        try await userEntityDataSource.update({ entity in
            entity.stories.first(where: { $0.id == storyId })?.isSeen = true
        }, where: #Predicate { $0.id == userId})
    }
    
    func toggleLike(userId: Int, storyId: Int) async throws {
        try await userEntityDataSource.update({ entity in
            entity.stories.first(where: { $0.id == storyId })?.isLiked.toggle()
        }, where: #Predicate { $0.id == userId})
    }
}
