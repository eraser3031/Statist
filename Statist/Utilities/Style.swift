//
//  Style.swift
//  Statist
//
//  Created by Kimyaehoon on 12/08/2021.
//

import SwiftUI

struct TaskButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(.systemBackground))
            .frame(height: 50).frame(maxWidth: 400)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.primary)
            )
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

