//
//  PostHeaderView.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct PostHeaderView: View {
    private let avatarUrl: String
    private let nickname: String
    private let location: String
    
    #warning("TODO: Remove default value in init")
    init(avatar: String = "",
         nickname: String,
         location: String) {
        self.avatarUrl = avatar
        self.nickname = nickname
        self.location = location
    }
    
    var body: some View {
        HStack(spacing: DSSpacing.xsmall.rawValue) {
            ImageLoaderView()
                .frame(width: 30, height: 30)
                .cornerRadius(30)
                .anyButton(.press) {}
            VStack(alignment: .leading) {
                Text(nickname)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .anyButton {}
                Text(location)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .anyButton {}
            }
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundColor(.primary)
                .anyButton(.highlight) {}
        }
        .padding(.horizontal, DSSpacing.xsmall.rawValue)
    }
}

#Preview {
    PostHeaderView(avatar: ImageLoaderView.Constants.randomImage,
                   nickname: "Joujou",
                   location: "Paris, France")
        
}
