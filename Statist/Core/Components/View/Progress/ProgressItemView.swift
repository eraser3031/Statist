//
//  ProgressItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct ProgressItemView: View {
    
    let entity: ProgressEntity
    let save: () -> Void
    
    var body: some View {
        VStack(spacing: 20){
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(entity.name ?? "")
                        .font(Font.system(.headline, design: .default).weight(.bold))
                        .lineLimit(1)
                    
                    Text(entity.kindEntity?.name ?? "")
                        .foregroundColor(entity.kindEntity?.color.toPrimary() ?? .primary)
                        .font(Font.system(.footnote, design: .default).weight(.semibold))
                        .lineLimit(1)
                }
                
                Spacer()
                
                ProgressButton(entity: entity) {
                    save()
                }
            }
            
            VStack(spacing: 10){
                
                ProgressBar(now: entity.now, goal: Int(entity.goal), entity.kindEntity?.color.toPrimary())
                
                HStack{
                    HStack(spacing: 2){
                        Text("\(entity.now)")
                            .foregroundColor(entity.kindEntity?.color.toPrimary())
                            .animation(.none)
                        Text("/")
                        Text("\(entity.goal)")
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    HStack(spacing: 2){
                        Text("\(entity.percent)")
                            .animation(.none)
                        Text("%")
                    }
                    .font(.footnote)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.theme.dividerColor)
                .padding(0.5)
        )
    }
}

//struct ProgressItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressItemView(model: .constant(Proj))
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
