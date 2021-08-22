//
//  CustomPicker.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import SwiftUI

protocol Pickerable {
    var id: String { get }
    var name: String { get }
    var labelImage: String { get }
}

enum SortCase: String, CaseIterable, Identifiable {
    
    var id: String {
        labelImage
    }
    
    var labelImage: String {
        switch self {
        case .name:
            return "textformat.size"
        case .date:
            return "calendar"
//        case .percent:
//            return "percent"
        }
    }
    
    case name
    case date
//    case percent
}

enum GoalCase: Pickerable, Identifiable {
    var id: String {
        name
    }
    
    var name: String {
        self == .finish ? "finish" : "recent"
    }
    
    var labelImage: String {
        self == .finish ? "flag" : "clock"
    }
    
    case finish
    case recent
}

struct CustomPicker<PickerableCase>: View where PickerableCase: Pickerable & Identifiable {
    
    @Namespace private var animation
    @Binding var currentPick: PickerableCase
    let picks: [PickerableCase]
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(picks) { pick in
                HStack(spacing: 6) {
                    Image(systemName: pick.labelImage)
                    Text(pick.name)
                }
                .font(Font.system(.subheadline, design: .default).weight(.medium))
                .padding(.horizontal, 15).padding(.vertical, 10)
                .overlay(
                    ZStack {
                    if currentPick.id == pick.id {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.primary, lineWidth: 2)
                            .padding(1)
                            .matchedGeometryEffect(id: "Picker", in: animation)
                    }
                }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.closeCard) {
                        currentPick = pick
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.theme.dividerColor)
        )
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.theme.backgroundColor)
        )
    }
}

//struct CustomPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPicker()
//    }
//}
