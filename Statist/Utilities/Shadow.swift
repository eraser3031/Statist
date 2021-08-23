//
//  Shadow.swift
//  Statist
//
//  Created by Kimyaehoon on 21/08/2021.
//

import Foundation
import SwiftUI

struct DividerShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 2)
    }
}

struct FloatShadowModifier: ViewModifier {
    var opacity: CGFloat = 0.2
    let radius: CGFloat
    let yOffset: CGFloat
    
    init(opacity: CGFloat = 0.2, radius: CGFloat, yOffset: CGFloat) {
        self.opacity = opacity
        self.radius = radius
        self.yOffset = yOffset
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.theme.shadowColor.opacity(opacity), radius: radius, x: 0, y: yOffset)
    }
}

extension View {
    func dividerShadow() -> some View {
        self.modifier(DividerShadowModifier())
    }
    
    func floatShadow(opacity: CGFloat = 0.2, radius: CGFloat = 40, yOffset: CGFloat = 20) -> some View {
        self.modifier(FloatShadowModifier(opacity: opacity, radius: radius, yOffset: yOffset))
    }
}
