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
            HStack(spacing: 12) {
                
                Spacer()
                    .frame(width: 8)
                
                ForEach(kinds) { kind in
                    Text(kind.name ?? "")
                        .font(Font.system(.subheadline, design: .default).weight(.medium))
                        .foregroundColor(selectedKind == kind ? Color(.systemBackground) : kind.color.primary())
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(selectedKind == kind ? kind.color.primary() : kind.color.secondary())
                        )
                        .contentShape(Rectangle())
                        .onTapGesture{
                            selectedKind = kind
                        }
                }

                Label("Edit", systemImage: "pencil")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.primary.opacity(0.05))
                    )
                    .onTapGesture {
                        showKindView = true
                    }
                
                Spacer()
                    .frame(width: 8)
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
