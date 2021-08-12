//
//  ProgressItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct ProgressItemView<ButtonView>: View where ButtonView: View {
    
    let entity: ProgressEntity
//    let save: () -> Void
    let content: () -> ButtonView
    
    init(
        entity: ProgressEntity,
        @ViewBuilder content: @escaping () -> ButtonView
    ){
        self.entity = entity
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 20){
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(entity.name ?? "")
                        .foregroundColor(entity.isFinish ? Color(.systemBackground) : .primary)
                        .font(Font.system(.headline, design: .default).weight(.bold))
                        .lineLimit(1)
                    
                    Text(entity.kindEntity?.name ?? "")
                        .foregroundColor(entity.isFinish ? Color(.systemBackground) : (entity.kindEntity?.color.toPrimary() ?? .primary))
                        .font(Font.system(.footnote, design: .default).weight(.semibold))
                        .lineLimit(1)
                }
                
                Spacer()
                
                self.content() // Progress Buttons
            }
            
            if entity.isNotFinish {
                VStack(spacing: 10){
                    
                    ProgressBar(now: entity.now, goal: Int(entity.goal), entity.kindEntity?.color.toPrimary())
                    
                    progressBarFootNote
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(entity.isFinish ? (entity.kindEntity?.color.toPrimary() ?? Color(.systemBackground)) : Color(.systemBackground) )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.theme.dividerColor)
                .padding(0.5)
        )
    }
}

extension ProgressItemView {
    private var progressBarFootNote: some View {
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

//struct ProgressItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressItemView(model: .constant(Proj))
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
