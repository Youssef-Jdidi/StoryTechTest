//
//  StoryUserEntitySwiftDataPersistence.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 22/05/2025.
//

import SwiftData
import SwiftUI

protocol SwiftDataPersistenceProtocol {
    func add(models: [StoryUser]) async throws
    func getAll(pageSize: Int, offset: Int) async throws -> [StoryUser]
    func getById(_ id: Int) async throws -> StoryUser?
    func update(_ updateBlock: @escaping (inout StoryUserEntity) -> Void, where predicate: Predicate<StoryUserEntity>?) async throws
    func getStoryById(_ id: Int) async throws -> Story?
}

@ModelActor
actor StoriesDataPersistence: SwiftDataPersistenceProtocol {
    private var context: ModelContext { modelExecutor.modelContext }

    func add(models: [StoryUser]) async throws {
        models.forEach { context.insert(StoryUserEntity.init(user: $0)) }
        try context.save()
    }
    
    func getAll(pageSize: Int, offset: Int) async throws -> [StoryUser] {
        var descriptor = FetchDescriptor<StoryUserEntity>(sortBy: [.init(\.id)])
        descriptor.fetchLimit = pageSize
        descriptor.fetchOffset = offset * pageSize
        return try context.fetch(descriptor).map(StoryUser.init)
    }
    
    func getById(_ id: Int) async throws -> StoryUser? {
        var descriptor = FetchDescriptor<StoryUserEntity>()
        descriptor.predicate = #Predicate { $0.id == id }
        return try context.fetch(descriptor).first.map(StoryUser.init)
    }
    
    func getStoryById(_ id: Int) async throws -> Story? {
        var descriptor = FetchDescriptor<StoryUserEntity>()
        descriptor.predicate = #Predicate { $0.id == id }
        let result = try context.fetch(descriptor).first
        return result?.stories.first(where: { $0.id == id }).map(Story.init)
    }

    func update(_ updateBlock: @escaping (inout StoryUserEntity) -> Void, where predicate: Predicate<StoryUserEntity>?) async throws {
        var descriptor = FetchDescriptor<StoryUserEntity>()
        descriptor.predicate = predicate
        var results = try context.fetch(descriptor)
        
        for i in results.indices {
            updateBlock(&results[i])
        }
        try context.save()
    }
}
