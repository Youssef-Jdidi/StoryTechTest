//
//  StoriesContainerViewModel.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import Factory

@Observable
class StoriesContainerViewModel {
    var users: [StoryUserDto] = []
    var isLoadingPage = false
    var shouldLoadNextPage = false
    
    private var currentPage = 1
    private let pageSize = 10
    private var canLoadMorePages = true
    private let storiesService: StoriesServiceProtocol

    init() {
        self.storiesService = Container.shared.storiesService()
    }

    func loadInitialAvatars() {
        guard users.isEmpty else { return }
        currentPage = 1
        canLoadMorePages = true
        users = []
        loadPage(page: currentPage)
    }
    
    func loadNextPage() {
        guard !isLoadingPage, canLoadMorePages else { return }
        currentPage += 1
        loadPage(page: currentPage)
    }
    
    private func loadPage(page: Int) {
        isLoadingPage = true
        Task {
            do {
                let users = try await storiesService.fetchUsersStories(pageSize: pageSize, page: page)
                if users.count < pageSize {
                    canLoadMorePages = false
                }
                self.users = users
            } catch {
                canLoadMorePages = false
            }
            isLoadingPage = false
            shouldLoadNextPage = false
        }
    }
}
