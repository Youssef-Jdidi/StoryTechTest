//
//  PostContainer.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct PostContainer: View {
    var body: some View {
        ForEach(0..<10, id: \.self) { index in
            LazyVStack {
                PostView()
                    .padding(.vertical, DSSpacing.small.rawValue)
            }
        }
    }
}
