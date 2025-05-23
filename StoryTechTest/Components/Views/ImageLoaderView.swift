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
    private let onLoaded: (() -> Void)?
    private let onError: (() -> Void)?
    
    init(urlString: String = Constants.randomImage,
         resizingMode: ContentMode = .fill,
         onLoaded: (() -> Void)? = nil,
         onError: (() -> Void)? = nil) {
        self.urlString = urlString
        self.resizingMode = resizingMode
        self.onLoaded = onLoaded
        self.onError = onError
    }
    
    var body: some View {
        Rectangle()
            .opacity(0.5)
            .overlay(
                WebImage(url: URL(string: urlString))
                    .onSuccess { _, _, _ in
                        onLoaded?()
                    }
                    .onFailure(perform: { error in
                        onError?()
                    })
                    .onProgress(perform: { _, _ in
                        // handle Loading
                    })
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
