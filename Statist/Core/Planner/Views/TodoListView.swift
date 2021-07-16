//
//  TodoListView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var environment: StatistViewModel
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
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: $vm.showAddTodoView,
                       onDismiss: {
                        withAnimation(.spring()){
                            vm.getTodoListEntitys(date: environment.date)
                        }
                    }) {
                        AddTodoView(date: environment.date)
                }
                .sheet(isPresented: $vm.showEditTodoView,
                       onDismiss: {
                        withAnimation(.spring()){
                            vm.getTodoListEntitys(date: environment.date)
                        }
                    }) {
                        EditTodoView($vm.editingEntity)
                }  
            }

//            Text(environment.date.description)
        }
        .onReceive(environment.$date) { date in
            withAnimation(.spring()) {
                vm.getTodoListEntitys(date: date)
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
            
            TodoItemView(model, editing: $vm.editingEntity, showEdit: $vm.showEditTodoView) {
                vm.save(date: environment.date)
            }
            .contextMenu {
                Button(action: { edit(model) }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(action: { moveBackDate(model) }) {
                    Label("Move back the date", systemImage: "calendar.badge.clock")
                }
                
                Divider()
                
                Button(action: { delete(model) }) {
                    Label("Delete", systemImage: "trash")
                }
            }
            .transition(.opacity)
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
    
    private func edit(_ model: TodoListEntity) {
        withAnimation(.spring()) {
            vm.editingEntity = model
        }
        vm.showEditTodoView = true
    }
    
    private func moveBackDate(_ model: TodoListEntity) {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: model.date ?? Date())
        model.date = newDate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                vm.save(date: environment.date)
            }
        }
    }
    
    private func delete(_ model: TodoListEntity) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                vm.deleteTodoListEntity(entity: model, date: environment.date)
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(date: Date())
    }
}


