//
//  ContentViewButtons.swift
//  ImageAnnotationTool
//
//  Created by Сергей on 12.04.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

private func calcOpacity(_ focused: Bool, _ pressed: Bool) -> Double {
    0.1 + (focused ? 0.2 : 0) + (pressed ? 0.2 : 0)
}

struct ZoomButton: View {
    @State var isFocused = false
    let action: () -> ()
    let label: String
    
    var body: some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.1)) {
            self.action()
            }
        }) { Text(label) }
            .buttonStyle(RoundButtonStyle(isFocused: isFocused))
            .onHover(perform: { isFocused in
                withAnimation(.easeInOut) {
                    self.isFocused = isFocused
                }
            })
    }
}

struct NavigationButton: View {
    @State var isFocused = false
    let action: () -> ()
    let label: String
    let height: CGFloat
    
    var body: some View {
        Button(action: { self.action() }) { Text(label) }
            .buttonStyle(NavigationButtonStyle(height: height, isFocused: isFocused))
            .onHover(perform: { isFocused in
                withAnimation(.easeInOut) {
                    self.isFocused = isFocused
                }
            })
    }
}

private struct RoundButtonStyle: ButtonStyle {
    var isFocused: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let radius = CGFloat(35.0)
        return ZStack {
            Circle()
                .frame(width: radius, height: radius)
                .opacity(calcOpacity(isFocused, configuration.isPressed))
                .shadow(radius: 2)
            configuration.label
                .font(.headline)
        }
        .frame(height: radius + 20, alignment: .top)
        .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

private struct NavigationButtonStyle: ButtonStyle {
    var height: CGFloat
    var isFocused: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 25, height: height)
                .opacity(calcOpacity(isFocused, configuration.isPressed))
            configuration.label
                .font(.headline)
        }
    }
}
