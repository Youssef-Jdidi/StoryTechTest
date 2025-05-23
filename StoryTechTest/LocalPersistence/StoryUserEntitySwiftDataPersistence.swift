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

actor StoriesDataPersistence: SwiftDataPersistenceProtocol {
    private let container: ModelContainer

    init() {
        self.container = try! ModelContainer(for: StoryUserEntity.self)
    }
    
    private func withMainContext<R>(_ block: @escaping (ModelContext) throws -> R) async throws -> R {
        try await MainActor.run {
            let context = container.mainContext
            return try block(context)
        }
    }
    
    func add(models: [StoryUser]) async throws {
        try await withMainContext { context in
            models.forEach { context.insert(StoryUserEntity.init(user: $0)) }
            try context.save()
        }
    }
    
    func getAll(pageSize: Int, offset: Int) async throws -> [StoryUser] {
        try await withMainContext { context in
            var descriptor = FetchDescriptor<StoryUserEntity>(sortBy: [.init(\.id)])
            descriptor.fetchLimit = pageSize
            descriptor.fetchOffset = offset * pageSize
            let result = try context.fetch(descriptor)
            return result.map(StoryUser.init)
        }
    }
    
    func getById(_ id: Int) async throws -> StoryUser? {
        try await withMainContext { context in
            var descriptor = FetchDescriptor<StoryUserEntity>()
            descriptor.predicate = #Predicate { $0.id == id }
            return try context.fetch(descriptor).first.map(StoryUser.init)
        }
    }
    
    func getStoryById(_ id: Int) async throws -> Story? {
        try await withMainContext { context in
            var descriptor = FetchDescriptor<StoryUserEntity>()
            descriptor.predicate = #Predicate { $0.id == id }
            let result = try context.fetch(descriptor).first
            return result?.stories.first(where: { $0.id == id }).map(Story.init)
        }
    }

    func update(_ updateBlock: @escaping (inout StoryUserEntity) -> Void, where predicate: Predicate<StoryUserEntity>?) async throws {
        try await withMainContext { context in
            var descriptor = FetchDescriptor<StoryUserEntity>()
            descriptor.predicate = predicate
            var results = try context.fetch(descriptor)
            
            for i in results.indices {
                updateBlock(&results[i])
            }
            
            try context.save()
        }
    }
}
