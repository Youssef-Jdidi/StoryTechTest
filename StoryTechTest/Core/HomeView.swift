//
//  HomeView.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                StoriesContainer(viewModel: StoriesContainerViewModel())
                Divider()
                PostContainer()
            }
            .navigationBarItems(
                leading: logoMenu,
                trailing: headerTrailing
            )
        }
    }
    
    private var headerTrailing: some View {
        HStack(spacing: DSSpacing.medium.rawValue) {
            Image(systemName: "plus.app")
                .anyButton {}
            Image(systemName: "heart")
                .anyButton {}
            Image(systemName: "paperplane")
                .anyButton {}
        }
        .foregroundColor(.primary)
    }
    
    private var logoMenu: some View {
        Menu {
            Button(action: {}) {
                Label("Following", systemImage: "plus.app")
            }
            Button(action: {}) {
                Label("Favourites", systemImage: "star")
            }
        } label: {
            Image("Logo")
        }
        .anyButton {}
    }
}

#Preview {
    HomeView()
}
