//
//  Modifier.swift
//  Statist
//
//  Created by Kimyaehoon on 08/08/2021.
//

import SwiftUI

struct GroupShapeModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.theme.dividerColor)
            )
    }
}

extension View {
    func groupShape(cornerRadius: CGFloat) -> some View {
        self.modifier(GroupShapeModifier(cornerRadius: cornerRadius))
    }
}
