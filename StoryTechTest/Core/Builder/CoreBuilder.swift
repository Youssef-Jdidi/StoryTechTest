//
//  CoreBuilder.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 23/05/2025.
//

import SwiftUI
import Factory
import SwiftfulRouting

extension Container {
    var coreBuilder: Factory<CoreBuilder> {
        self {
            CoreBuilder()
        }.cached
    }
}

@MainActor
protocol GlobalRouter {
    var router: AnyRouter { get }
}

extension GlobalRouter {
    
    func dismissScreen() {
        router.dismissAllScreens(animates: false)
    }
}

@MainActor
protocol Builder {
    associatedtype Screen: View
    func build() -> Screen
}

@MainActor
struct CoreBuilder: Builder {
    typealias Screen = RootTabView

    nonisolated init() {}
    
    func build() -> RootTabView {
        RootTabView(screens: [
            TabBarScreen(systemImage: "house") {
                HomeView().asAnyView()
            },
            TabBarScreen(systemImage: "magnifyingglass") { Text("Search").asAnyView() },
            TabBarScreen(systemImage: "play.rectangle") { Text("Reels").asAnyView() },
            TabBarScreen(systemImage: "bag") { Text("bag").asAnyView() },
            TabBarScreen(systemImage: "person.crop.circle") { Text("Profile").asAnyView() }
        ])
    }

    @ViewBuilder
    func createStoryViewer(userId: Int, router: AnyRouter) -> some View {
        StoryViewer(viewModel: StoryViewerViewModel(userId: userId, router: CoreRouting(router: router)))
    }
}

@MainActor
struct CoreRouting {
    @Injected(\.coreBuilder) private var coreBuilder
    let router: AnyRouter
    
    nonisolated init(router: AnyRouter) {
        self.router = router
    }
    
    func showUserStory(userId: Int, option: SegueOption) async {
        router.showScreen(option) { router in
            coreBuilder.createStoryViewer(userId: userId, router: router)
        }
    }
}
