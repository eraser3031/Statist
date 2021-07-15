//
//  TodoItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI

struct TodoItemView: View {
    
    let model: TodoListEntity
    @Binding var editingEntity: TodoListEntity?
    @Binding var showEditTodoView: Bool
    var save: () -> Void
    
    init(_ model: TodoListEntity, editing: Binding<TodoListEntity?>, showEdit: Binding<Bool>, save: @escaping () -> Void) {
        self.model = model
        self._editingEntity = editing
        self._showEditTodoView = showEdit
        self.save = save
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: model.isDone ? "checkmark.circle.fill" : "circle")
                    .font(Font.system(.title3, design: .default).weight(.semibold))
                
                Text(model.name ?? "")
                    .font(.footnote)
                    .lineLimit(1)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring()) {
                    model.isDone.toggle()
                    save()
                }
            }
//            Image(systemName: "xmark.circle.fill")
//                .font(Font.system(.title3, design: .default).weight(.semibold))
//                .padding(14)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    withAnimation(.spring()) {
//                        editingEntity = model
//                    }
//                    showEditTodoView = true
//                }
        }
        .padding(12)
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
    }
}
