//
//  StoryTechTestApp.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

@main
struct StoryTechTestApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}


