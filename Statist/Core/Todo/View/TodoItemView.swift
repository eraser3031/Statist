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
                withAnimation(.easeInOut) {
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

struct NewTodoItemView: View {
    
    let model: TodoListEntity
    @ObservedObject var vm: TodoViewModel
    
    let primaryColor: Color
    
    init(_ model: TodoListEntity, vm: TodoViewModel) {
        self.model = model
        self.vm = vm
        self.primaryColor = model.kindEntity?.color.toPrimary() ?? .primary
    }
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: model.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.callout)
                Text(model.name ?? "")
                    .font(.footnote)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.openCard) {
                    vm.toggle(model)
                }
            }

            Menu {
                Button(action: { vm.edit(model) }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(action: { vm.moveBackDate(model) }) {
                    Label("Move back the date", systemImage: "calendar.badge.clock")
                }
                
                Divider()
                
                Button(action: { vm.deleteEntity(entity: model) }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundColor(Color(.systemGray))
                    .padding(5).padding(.horizontal, 2)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.theme.itemBackgroundColor)
                    )
                    .padding(2)
            }
        }
        .foregroundColor(model.isDone ? primaryColor : .primary )
        .padding(12)
        .padding(.vertical, model.isDone ? 0 : 3)
        .background(Color(.systemBackground))
        .overlay(
            ZStack(alignment: .leading){
                Capsule()
                    .fill(Color.theme.dividerColor)
                    .frame(height: 2)
                    .padding(.horizontal, 14)
            
                Capsule()
                    .fill(primaryColor)
                    .frame(maxWidth: model.isDone ? .infinity : 0)
                    .frame(height: 2)
                    .padding(.horizontal, 14)
            }
            ,alignment: .bottom
        )
    }
}
