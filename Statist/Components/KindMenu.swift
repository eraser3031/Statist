//
//  KindMenu.swift
//  Statist
//
//  Created by Kimyaehoon on 18/08/2021.
//

import SwiftUI

struct KindMenu: View {
    
    @Binding var selectedKind: KindEntity?
    @Binding var showKindMenuView: Bool
    let kinds: [KindEntity]
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(selectedKind?.color.toPrimary() ?? Color.primary)
                        .frame(width: 10, height: 10)
                    
                    Text(selectedKind?.name ?? "Select Kind")
                        .lineLimit(1)

                        .font(Font.system(.subheadline, design: .default).weight(.medium))
                }
                
                Image(systemName: "chevron.down")
                    .font(Font.system(.footnote, design: .default).weight(.semibold))
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color.theme.groupBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.theme.dividerColor))
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.closeCard) {
                    showKindMenuView = true
                }
            }
        }
    }
}

struct KindMenuSheet: View {
    @Binding var selectedKind: KindEntity?
    @Binding var showKindMenuView: Bool
    @Binding var showKindView: Bool
    let kinds: [KindEntity]
    
    var body: some View {
        VStack(spacing: 4) {
            
            Color.theme.dividerColor
                .frame(width: 48, height: 5)
                .clipShape(Capsule())
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(kinds) { kind in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(kind.color.toPrimary())
                                .frame(width: 12, height: 12)
                            
                            Text(kind.name ?? "")
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.closeCard) {
                                selectedKind = kind
                                showKindMenuView = false
                            }
                        }
                        Divider()
                    }
                }
            }
        }
    }
}
