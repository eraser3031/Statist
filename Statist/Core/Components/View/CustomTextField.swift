//
//  CustomTextField.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI

struct CustomTextField: View {
    
    var description: String = ""
    @Binding var text: String
    
    init(_ description: String, text: Binding<String>) {
        self.description = description
        self._text = text
    }
    
    var body: some View {
        TextField(description, text: $text)
            .foregroundColor(.primary)
            .disableAutocorrection(true)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(.secondary)
                    .opacity(text.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        text = ""
                    }
                , alignment: .trailing
            )
            .font(.footnote)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.dividerColor)
            )
    }
}
