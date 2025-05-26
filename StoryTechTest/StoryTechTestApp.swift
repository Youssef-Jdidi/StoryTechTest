//
//  StoryTechTestApp.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI
import Factory

@main
struct StoryTechTestApp: App {
    private let coreBuiler: CoreBuilder
    
    var body: some Scene {
        WindowGroup {
            coreBuiler.build()
        }
    }
    
    init() {
        self.coreBuiler = Container.shared.coreBuilder()
    }
}


