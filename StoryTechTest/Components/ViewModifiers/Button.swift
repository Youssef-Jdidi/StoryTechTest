//
//  Button.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import SwiftUI

private struct HighlightButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                configuration.isPressed ? Color.blue.opacity(0.4) : Color.blue.opacity(0)
            }
            .animation(.smooth, value: configuration.isPressed)
    }
}

private struct PressableButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case press, highlight, plain
}

extension View {
    
    @ViewBuilder
    func anyButton(_ option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
            case .press:
                self.pressableButton(action: action)
            case .highlight:
                self.highlightButton(action: action)
            case .plain:
                self.plainButton(action: action)
        }
    }
    
    private func plainButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func highlightButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(HighlightButtonStyle())
    }
    
    private func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    VStack {
        Text("Hello, world!")
            .padding()
            .frame(maxWidth: .infinity)
            .tappableBackground()
            .anyButton(.highlight, action: {
                
            })
            .padding()
        
        Text("Hello, world!")
            .callToActionButton()
            .anyButton(.press, action: {
                
            })
            .padding()
        
        Text("Hello, world!")
            .callToActionButton()
            .anyButton(action: {
                
            })
            .padding()
        
        Image(systemName: "person.fill")
            .resizable()
            .tappableBackground()
            .anyButton(.highlight) {
                
            }
            .clipShape(Circle())
            .frame(width: 24, height: 24)
            .padding()
    }
}
