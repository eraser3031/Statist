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
    @Binding var showAddKindView: Bool
    let kinds: [KindEntity]
    
    init(_ selectedKind: Binding<KindEntity?>, showAddKindView: Binding<Bool>, kinds: [KindEntity]) {
        self._selectedKind = selectedKind
        self._showAddKindView = showAddKindView
        self.kinds = kinds
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(kinds) { kind in
                    HStack(spacing: 16) {
                        Circle()
                            .fill(kind.color.toPrimary())
                            .frame(width: 12, height: 12)
                        Text(kind.name ?? "")
                            .font(Font.system(.subheadline, design: .default).weight(.bold))
                    }
                    .padding(18)
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.systemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(isSelected(kind: kind) ? Color.primary : Color.theme.dividerColor,
                                    lineWidth:isSelected(kind: kind) ? 3 : 1)
                            .padding(isSelected(kind: kind) ? 1.5 : 0.5)
                    )
                    .onTapGesture{
                        selectedKind = kind
                    }
                }

                Image(systemName: "plus")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                    .padding(18)
                    .padding(.horizontal, 22)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.theme.itemBackgroundColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.theme.dividerColor)
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showAddKindView = true
                        }
                    }
                    .sheet(isPresented: $showAddKindView) {
                        AddKindView()
                    }
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
