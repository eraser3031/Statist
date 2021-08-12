//
//  CustomPicker.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct CustomPicker: View {
    
    @Binding var pickedItem: PickerItemOption
    let items: [PickerItemOption]
    
    init(_ pickedItem: Binding<PickerItemOption>, items: [PickerItemOption]){
        self._pickedItem = pickedItem
        self.items = items
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                PickerItem($pickedItem, item: item)
                    .overlay(
                        Divider()
                            .foregroundColor(.theme.dividerColor),
                        alignment: .trailing
                    )
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
//            Rectangle()
                .stroke(Color.theme.dividerColor, lineWidth: 0.5)
        )
    }
}

struct CustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomPicker(.constant(.TimeTable), items: [.TodoList, .TimeTable, .Progress])
                .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
            
            CustomPicker(.constant(.TodoList), items: [.TodoList, .TimeTable, .Progress])
                .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
