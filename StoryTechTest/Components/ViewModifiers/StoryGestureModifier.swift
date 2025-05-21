//
//  StoryGestureModifier.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

struct StoryGestureModifier: ViewModifier {
    let onTapLeft: () -> Void
    let onTapRight: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    
    @State private var pressTimer: Timer?
    @State private var didTriggerPause = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if pressTimer == nil {
                                didTriggerPause = false
                                pressTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                    didTriggerPause = true
                                    onPause()
                                }
                            }
                        }
                        .onEnded { value in
                            pressTimer?.invalidate()
                            pressTimer = nil
                            
                            if didTriggerPause {
                                onResume()
                            } else {
                                handleTap(location: value.location, in: geometry)
                            }
                        }
                )
        }
    }

    private func handleTap(location: CGPoint, in geometry: GeometryProxy) {
        if location.x < geometry.size.width / 2 {
            onTapLeft()
        } else {
            onTapRight()
        }
    }
    
}

extension View {
    func storyGestures(
        onTapLeft: @escaping () -> Void,
        onTapRight: @escaping () -> Void,
        onPause: @escaping () -> Void,
        onResume: @escaping () -> Void
    ) -> some View {
        modifier(
            StoryGestureModifier(
                onTapLeft: onTapLeft,
                onTapRight: onTapRight,
                onPause: onPause,
                onResume: onResume
            )
        )
    }
}
