//
//  TodoListView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject var vm: TodoListViewModel
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: TodoListViewModel(date: date))
    }
    
    private func binding(for item: TodoListEntity) -> Binding<TodoListEntity> {
        guard let index = vm.todoListEntitys.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $vm.todoListEntitys[index]
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 50) {
                    VStack(alignment: .leading, spacing: 10){
                        if vm.todoListEntitys.isEmpty {
                            empty
                        } else {
                            todoList
                        }
                    }
                    
                    CustomButton("Add", "plus") {
                        vm.showAddTodoView = true
                    }
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: $vm.showAddTodoView,
                       onDismiss: {
                        withAnimation(.spring()){
                            vm.getTodoListEntitys()
                        }
                    }) {
                        AddTodoView(date: vm.date)
                }
                .sheet(isPresented: $vm.showEditTodoView,
                       onDismiss: {
                        withAnimation(.spring()){
                            vm.getTodoListEntitys()
                        }
                    }) {
                        EditTodoView($vm.editingEntity)
                }  
            }
        }
    }
}

extension TodoListView {
    private var todoList: some View {
        ForEach(vm.todoListEntitys.indexed(), id: \.element.id) { (index, model) in
            if vm.sectionIndexes.contains(index) {
                Text(model.kindEntity?.name ?? "")
                    .font(Font.system(.headline, design: .default).weight(.bold))
                    .foregroundColor(model.kindEntity?.color.toPrimary() ?? Color.primary)
                    .padding(.top, 10)
            }
            
            TodoItemView(binding(for: model), editing: $vm.editingEntity, showEdit: $vm.showEditTodoView) {
                vm.save()
            }
        }
    }
    
    private var empty: some View {
        Rectangle()
            .fill(Color(.systemBackground))
            .frame(height: 300)
            .overlay(
                Text("Empty")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            )
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(date: Date())
    }
}
