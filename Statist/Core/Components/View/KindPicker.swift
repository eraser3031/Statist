//
//  KindPicker+AddView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI
import CoreData

struct KindPicker: View {
    
    @StateObject var vm = KindViewModel()
    @State var selectedKindEntity: KindEntity?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(vm.kindEntitys) { kindEntity in
                    HStack(spacing: 16) {
                        Circle()
                            .fill(kindEntity.color.toPrimary())
                            .frame(width: 12, height: 12)
                        Text(kindEntity.name ?? "")
                            .font(Font.system(.subheadline, design: .default).weight(.bold))
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.systemBackground))
                    )
                    .onTapGesture{
                        selectedKindEntity = kindEntity
                    }
                }
                
                Image(systemName: "plus")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                    .padding(14)
                    .padding(.horizontal, 20)
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
                            vm.showAddKindView = true
                        }
                    }
            }
        }
    }
}
//
//struct KindPicker_AddView_Previews: PreviewProvider {
//    static var previews: some View {
//        KindPicker(vm: KindViewModel(), selectedKind: .con)
//    }
//}
