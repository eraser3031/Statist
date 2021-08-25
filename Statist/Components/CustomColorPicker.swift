//
//  CustomColorPicker.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI

struct CustomColorPicker: View {
    
    @Binding var selectedColorKind: ColorKind?
    
    init(_ selectedColorKind: Binding<ColorKind?>) {
        self._selectedColorKind = selectedColorKind
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                
                Spacer()
                    .frame(width: 4)
                
                ForEach(ColorKind.allCases) { colorKind in
                    Circle()
                        .fill(colorKind.primary())
                        .frame(width: 48, height: 48)
                        .overlay(
                            ZStack {
                                Circle()
                                    .stroke(Color.primary, lineWidth: 3)
                                    .padding(1.5)
                            
                                Image(systemName: "checkmark")
                                    .font(Font.system(.subheadline, design: .default).weight(.heavy))
                                    .foregroundColor(Color(.systemBackground))
                            }
                            .opacity((colorKind.id == (selectedColorKind?.id ?? "")) ? 1 : 0)
                        )
                        .onTapGesture{
                            selectedColorKind = colorKind
                        }
                }
                
                Spacer()
                    .frame(width: 4)
            }
        }
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(.constant(ColorKind.blue))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
