//
//  TodoItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI

struct TodoItemView: View {
    
    @Binding var model: TodoListEntity
    var save: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: model.isDone ? "checkmark.circle.fill" : "circle")
                .font(Font.system(.title3, design: .default).weight(.semibold))
            
            Text(model.name ?? "")
                .font(.footnote)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(10)
        .padding(.vertical, model.isDone ? 0 : 4)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(
                    model.isDone ? (model.kindEntity?.color.toPrimary() ?? Color.primary) : (model.kindEntity?.color.toSecondary() ?? Color(.tertiaryLabel))
                )
        )
        .foregroundColor(
            model.isDone ? Color(.systemBackground) : (model.kindEntity?.color.toPrimary() ?? Color.primary)
        )
        .onTapGesture {
            withAnimation(.spring()) {
                model.isDone.toggle()
                save()
            }
        }
        
    }
}

//struct TodoItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            TodoItemView(model: .constant(dev.todoModel1))
//                .frame(width: 300)
//                .padding()
//            .previewLayout(.sizeThatFits)
//        }
//    }
//}
