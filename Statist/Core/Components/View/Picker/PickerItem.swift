//
//  PickerItem.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct PickerItem: View {
    @Binding var pickedItem: PickerItemOption
    var item: PickerItemOption
    
    init(_ pickedItem: Binding<PickerItemOption>, item: PickerItemOption){
        self._pickedItem = pickedItem
        self.item = item
    }
    
    var body: some View {
        Image(systemName: item.symbol)
            .font(Font.system(.footnote, design: .default).weight(.bold))
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .onTapGesture {
                withAnimation(.spring()) {
                    pickedItem = item
                }
            }
            .foregroundColor(
                pickedItem == item ? Color(.systemBackground) : Color.primary 
            )
            .background(
                pickedItem == item ? Color.primary : Color(.systemBackground) 
            )
    }
}

struct PickerItem_Previews: PreviewProvider {
    static var previews: some View {
        PickerItem(.constant(.TodoList), item: .TodoList)
            .previewLayout(.sizeThatFits)
    }
}

enum PickerItemOption: String, Identifiable {
    
    var id: String {
        return self.rawValue
    }
    
    var symbol: String {
        switch self {
        case .TodoList:
            return "checkmark.circle"
        case .TimeTable:
            return "rectangle.split.3x3"
        case .Progress:
            return "chart.line.uptrend.xyaxis"
        }
    }
    
    case TodoList
    case TimeTable
    case Progress
}
