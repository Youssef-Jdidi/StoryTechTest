//
//  RootTabView.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct TabBarScreen: Identifiable {
    let id: UUID = UUID()
    let systemImage: String
    @ViewBuilder var screen: () -> AnyView
}

struct RootTabView: View {
    private let screens: [TabBarScreen]
    
    init(screens: [TabBarScreen]) {
        self.screens = screens
    }
    
    var body: some View {
        TabView {
            ForEach(screens) { tab in
                tab.screen()
                    .tabItem {
                        Image(systemName: tab.systemImage)
                    }
            }
        }
        .tint(.primary)
        .foregroundColor(.primary)
    }
}

#Preview {
    RootTabView(screens: [
        TabBarScreen(systemImage: "house") { AnyView(Text("house")) },
        TabBarScreen(systemImage: "magnifyingglass") { AnyView(Text("magnifyingglass")) },
        TabBarScreen(systemImage: "play.rectangle") { AnyView(Text("play.rectangle")) },
        TabBarScreen(systemImage: "bag") { AnyView(Text("bag")) },
        TabBarScreen(systemImage: "person.crop.circle") { AnyView(Text("person.crop.circle")) }
    ])
}
