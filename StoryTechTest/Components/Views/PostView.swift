//
//  PostView.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack {
            PostHeaderView(nickname: "Youssef", location: "Bordeaux")
            CarouselView(items: ["1", "2", "3"]) { _ in
                ImageLoaderView()
            }
            PostFooterView(likesCount: 1500)
        }
    }
}

#Preview {
    PostView()
}
