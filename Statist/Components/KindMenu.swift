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
        Button(action: {
            withAnimation(.closeCard) {
                showKindMenuView = true
            }
        }){
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
        }
        .buttonStyle(InteractiveButtonStyle())
    }
}

struct KindMenuSheet: View {
    @Binding var selectedKind: KindEntity?
    @Binding var showKindMenuView: Bool
    @Binding var showKindView: Bool
    let kinds: [KindEntity]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Text("Kinds")
                        .font(Font.system(.headline, design: .default).weight(.bold))
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showKindView = true
                        }
                    }) {
                        Label("Edit", systemImage: "pencil")
                            .font(Font.system(.footnote, design: .default).weight(.semibold))
                            .foregroundColor(Color(.systemGray))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.theme.itemBackgroundColor)
                            )
                    }
                }
                
                Divider()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10){
                    ForEach(kinds) { kind in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(kind.color.toPrimary())
                                .frame(width: 12, height: 12)
                            
                            Text(kind.name ?? "")
                                .font(Font.system(.subheadline, design: .default).weight(.medium))
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.theme.itemBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .onTapGesture {
                            selectedKind = kind
                            withAnimation(.linear(duration: 0.1)) {
                                showKindMenuView = false
                            }
                        }
                    }
                }
            }
        }.padding([.horizontal, .top])
        .background(Color.theme.subBackgroundColor )
        .frame(height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
    }
}
