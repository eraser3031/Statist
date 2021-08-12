//
//  ProgressButton.swift
//  Statist
//
//  Created by Kimyaehoon on 20/07/2021.
//

import SwiftUI

struct ProgressButton: View {
    
    let entity: ProgressEntity
    let manager = CoreDataManager.instance
    var save: () -> Void
    
    var body: some View {
        HStack(spacing: 10){
            buttonShape(isPrimary: false)
                .onTapGesture {
                    for data in (entity.progressPoints?.allObjects ?? []) {
                        if let data = data as? ProgressPoint {
                            if (data.date ?? Date().toDay()) == Date().toDay() {
                                manager.context.delete(data)
                            }
                        }
                    }
                    withAnimation(.spring()) {
                        save()
                    }
                }
            
            buttonShape(isPrimary: true)
                .onTapGesture {
                    let newPoint = ProgressPoint(context: manager.context)
                    newPoint.date = Date().toDay()
                    newPoint.id = UUID().uuidString
                    newPoint.progressEntity = entity
                    withAnimation(.spring()) {
                        save()
                    }
                }
        }
    }
}

extension ProgressButton {
    private func buttonShape(isPrimary: Bool) -> some View {
        ZStack{
            if isPrimary {
                Circle()
                    .fill(entity.kindEntity?.color.toPrimary() ?? Color.primary)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "arrow.right")
                            .font(Font.system(.footnote, design: .default).weight(.bold))
                            .foregroundColor(Color(.systemBackground))
                    )
            } else {
                Circle()
                    .stroke(Color.theme.dividerColor)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "arrow.uturn.left")
                            .font(Font.system(.footnote, design: .default).weight(.bold))
                    )
            }
        }
        .contentShape(Circle())
    }
}

//struct ProgressButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressButton()
//    }
//}
