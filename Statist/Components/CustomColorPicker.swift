//
//  CustomColorPicker.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI

struct CustomColorPicker: View {
    
    @Binding var selectedColorKind: ColorKind?
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 48, maximum: 48), spacing: 16)
    ]
    
    
    init(_ selectedColorKind: Binding<ColorKind?>) {
        self._selectedColorKind = selectedColorKind
    }
    
    var body: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 16) {
            ForEach(ColorKind.allCases) { colorKind in
                let isSelected = colorKind.id == (selectedColorKind?.id ?? "")
                
                Circle()
                    .fill(isSelected ? colorKind.primary() : colorKind.secondary() )
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(Font.system(.subheadline, design: .default).weight(.heavy))
                            .foregroundColor(Color(.systemBackground))
                            .opacity(isSelected ? 1 : 0)
                    )
                    .onTapGesture{
                        withAnimation(.closeCard) {
                            selectedColorKind = colorKind
                        }
                    }
            }
        }
    }
}

//struct CustomColorPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomColorPicker(.constant(ColorKind.blue))
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}

//struct NewCustomColorPicker: View {
//    var body: some View {
//        
//    }
//}
