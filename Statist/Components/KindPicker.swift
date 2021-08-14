//
//  KindPicker+AddView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI
import CoreData
 
struct KindPicker: View {

    @Binding var selectedKind: KindEntity?
    @Binding var showKindView: Bool
    let kinds: [KindEntity]
    
    init(_ selectedKind: Binding<KindEntity?>, showKindView: Binding<Bool>, kinds: [KindEntity]) {
        self._selectedKind = selectedKind
        self._showKindView = showKindView
        self.kinds = kinds
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Spacer()
                    .frame(width: 4)
                ForEach(kinds) { kind in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(kind.color.toPrimary())
                            .frame(width: 10, height: 10)
                        Text(kind.name ?? "")
                            .font(Font.system(.caption, design: .default).weight(.bold))
                            .foregroundColor(isSelected(kind: kind) ? Color(.systemBackground) : Color.primary)
                    }
                    .modifier(CapsuleItemModifier())
                    .background(
                        isSelected(kind: kind) ? Color.primary : Color(.systemBackground)
                    )
                    .clipShape(Capsule())
                    .contentShape(Rectangle())
                    .onTapGesture{
                        selectedKind = kind
                    }
                }

                Image(systemName: "pencil")
                    .font(Font.system(.caption, design: .default).weight(.bold))
                    .padding(16)
                    .background(Circle().fill(Color(.systemBackground)))
                    .overlay(
                        Circle()
                            .stroke(Color.theme.dividerColor)
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showKindView = true
                        }
                    }
                Spacer()
                    .frame(width: 4)
            }
        }
    }
    
    private func isSelected(kind: KindEntity) -> Bool {
        if let selectedKind = selectedKind {
            return (selectedKind.id ?? "") == (kind.id ?? "/")
        } else {
            return false
        }
    }
}

//struct KindPicker_AddView_Previews: PreviewProvider {
//    static var previews: some View {
//        KindPicker()
//    }
//}

struct CapsuleItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .padding(.horizontal, 8)
    }
}
