//
//  StoriesService.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import Foundation
import Factory
import SwiftData

extension Container {
    var storiesService: Factory<StoriesServiceProtocol> {
        self { StoriesService() }.cached
    }
    
    var userEntityDataSource: Factory<any StoriesDataPersistenceProtocol> {
        let container = try! ModelContainer(for: StoryUserEntity.self,
                                            configurations: ModelConfiguration())
        return self { StoriesDataPersistence(modelContainer: container)}.cached
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
    private let userEntityDataSource: any StoriesDataPersistenceProtocol
    private let syncData: SyncData
    private var userStories: [StoryUser] = []

    init(networkingManager: NetworkingProtocol = Container.shared.networkingManager(.local),
         userEntityDataSource: any StoriesDataPersistenceProtocol = Container.shared.userEntityDataSource(),
         syncData: SyncData = SyncData()) {
        self.networkingManager = networkingManager
        self.userEntityDataSource = userEntityDataSource
        self.syncData = syncData
    }
    
    func fetchUsersStories(pageSize: Int, page: Int) async throws -> [StoryUser] {
        try? await Task.sleep(nanoseconds: 500_000_000) // MOCK Delay
        let result = try await userEntityDataSource.getAll(pageSize: pageSize, offset: page)
        if result.isEmpty {
            try await syncData()
            self.userStories = try await userEntityDataSource.getAll(pageSize: pageSize, offset: page)
            return userStories
        }
        self.userStories = result
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

struct SyncData {
    private let networkingManger: NetworkingProtocol
    private let storiesDataSource: any StoriesDataPersistenceProtocol
    
    init(networkingManger: NetworkingProtocol = Container.shared.networkingManager(.local),
         storiesDataSource: any StoriesDataPersistenceProtocol = Container.shared.userEntityDataSource()) {
        self.networkingManger = networkingManger
        self.storiesDataSource = storiesDataSource
    }
    
    func callAsFunction() async throws {
        // Check if SwiftData populated
        let result = try await storiesDataSource.getAll(pageSize: 1, offset: 1)
        // If the result is empty, fetch from Networking and populate SwiftData
        guard result.isEmpty else { return }
        let dtos: [StoryUserDto] = try await networkingManger.fetchData(from: .fetchStories)
        let data = dtos.map(StoryUser.init)
        // Save the fetched data to SwiftData
        try await storiesDataSource.add(models: data)
    }
}
