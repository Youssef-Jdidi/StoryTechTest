//
//  StoryRouter.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 23/05/2025.
//

import Foundation
import SwiftfulRouting

protocol StoryRouter: GlobalRouter {
    func showUserStory(userId: Int, option: SegueOption) async
}

extension CoreRouting: StoryRouter {}
