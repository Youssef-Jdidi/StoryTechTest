//
//  PostFooterView.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct PostFooterView : View {
    private let likesCount: Int?
    
    init(likesCount: Int?) {
        self.likesCount = likesCount
    }
    
    var body: some View {
        HStack {
            HStack(spacing: DSSpacing.xxxsmall.rawValue) {
                Image(systemName: "heart")
                    .anyButton {
                        
                    }
                if let count = likesCount {
                    Text("\(count)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
            Image(systemName: "message")
            Image(systemName: "paperplane")
            Spacer()
            Image(systemName: "bookmark")
        }
        .padding(.horizontal, DSSpacing.xsmall.rawValue)
    }
}
