//
//  StoryUser.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import Foundation

struct Story: Equatable, Identifiable {
    let id: Int
    let url: String
    var progress: CGFloat = 0
    var isLiked: Bool
    var isSeen: Bool
}
