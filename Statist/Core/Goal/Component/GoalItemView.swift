//
//  GoalItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import SwiftUI

struct GoalItemView: View {
    @Binding var entity: GoalEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                HStack(spacing: 4) {
                    Circle()
                        .fill(entity.kindEntity?.color.toPrimary() ?? Color.primary)
                        .frame(width: 8, height: 8)
                    
                    Text(entity.kindEntity?.name ?? "Kind")
                        .font(Font.system(.caption, design: .default).weight(.bold))
                }
                .padding(.horizontal, 10).padding(.vertical, 5)
                .overlay(Capsule().stroke(Color.theme.dividerColor))
                
                Spacer()
                
                Text(entity.endDate?.string() ?? "∞")
                    .font(Font.system(.caption, design: .default).weight(.bold))
                    .foregroundColor(Color(.darkGray))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.theme.subBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entity.name ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("\(entity.now) \\ \(Int(entity.goal))")
                    .font(Font.system(.headline, design: .default).weight(.heavy))
                    .italic()
            }
            
            Capsule()
                .fill(Color.theme.dividerColor)
                .frame(maxWidth: .infinity).frame(height: 1)
                .overlay(
                    GeometryReader { geo in
                        Capsule()
                            .fill(entity.kindEntity?.color.toPrimary() ?? Color.primary)
                            .frame(width: geo.size.width * entity.percentForCalcurate, height: 1)
                    }
                )
        }
        .padding(16)
        .background(Color.theme.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.theme.dividerColor))
    }
}

//struct GoalItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalItemView()
//    }
//}
