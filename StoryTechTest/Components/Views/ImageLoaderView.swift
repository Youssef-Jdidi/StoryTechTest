//
//  ImageLoaderView.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {

    enum Constants {
        static let randomImage = "https://picsum.photos/600/600"
    }

    private let urlString: String
    private let resizingMode: ContentMode
    
    init(urlString: String = Constants.randomImage,
         resizingMode: ContentMode = .fill) {
        self.urlString = urlString
        self.resizingMode = resizingMode
    }
    
    var body: some View {
        Rectangle()
            .opacity(0.5)
            .overlay(
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.progress)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            )
            .clipped()
    }
}

#Preview {
    ImageLoaderView()
        .frame(width: .infinity, height: 300)
        .anyButton(.highlight) {
            
        }
}
