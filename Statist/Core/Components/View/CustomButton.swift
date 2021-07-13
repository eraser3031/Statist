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
    
    init(_ name: String, _ label: String?, action: @escaping () -> Void) {
        self.name = name
        self.label = label
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
            .font(Font.system(.headline, design: .default).weight(.semibold))
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.primary)
            )
            .foregroundColor(Color(.systemBackground))
        }
    }
}
