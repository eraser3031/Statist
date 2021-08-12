//
//  CustomButton.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI

struct CustomButton: View {
    
    let label: String?
    let name: String
    let action: () -> Void
    var isPrimary = true
    
    init(_ name: String, _ label: String?, isPrimary: Bool = true, action: @escaping () -> Void) {
        self.name = name
        self.label = label
        self.isPrimary = isPrimary
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {            
            HStack(spacing: 16){
                if let label = label {
                    Image(systemName: label)
                }
                Text(name)
            }
            .font(Font.system(.headline, design: .default).weight(.bold))
            .frame(maxWidth: 360)
            .padding(.vertical, 16)
            .background(
                isPrimary ?
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.primary) : nil
            )
            .background(
                !isPrimary ?
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.theme.dividerColor) : nil
            )
            .foregroundColor(isPrimary ?
                             Color(.systemBackground) : Color.primary)
        }
    }
}
