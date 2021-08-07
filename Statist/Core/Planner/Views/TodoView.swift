//
//  TodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI

struct TodoView: View {
    
    @StateObject var vm: TodoViewModel
    @StateObject var calendarVM = CalendarViewModel()
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: TodoViewModel(date: date))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            GroupedCalendarView(vm: calendarVM)
                .shadow(color: Color(#colorLiteral(red: 0.1333333, green: 0.3098039, blue: 0.662745, alpha: 0.14)), radius: 14, x: 0.0, y: 8)
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10){
                    if vm.todoListEntitys.isEmpty {
                        empty
                    } else {
                        todoList
                    }
                }
            }
        }
        .onReceive(calendarVM.$date) { date in
            withAnimation(.spring()) {
                vm.getTodoListEntitys(date: date)
            }
        }
    }
    
    //  MARK: - Components
    
    private var todoList: some View {
//        ForEach(vm.todoListEntitys.indexed(), id: \.element.id) { (index, model) in
//            if vm.sectionIndexes.contains(index) {
//                Text(model.kindEntity?.name ?? "")
//                    .font(Font.system(.headline, design: .default).weight(.bold))
//                    .foregroundColor(model.kindEntity?.color.toPrimary() ?? Color.primary)
//                    .padding(.top, 10)
//                    .id(model.kindEntity?.name ?? "")
//            }
//
//            NewTodoItemView(model: model, editModel: vm.$editingEntity, toggle: model.toggle)
//            .contextMenu {
//                Button(action: { edit(model) }) {
//                    Label("Edit", systemImage: "pencil")
//                }
//
//                Button(action: { moveBackDate(model) }) {
//                    Label("Move back the date", systemImage: "calendar.badge.clock")
//                }
//
//                Divider()
//
//                Button(action: { delete(model) }) {
//                    Label("Delete", systemImage: "trash")
//                }
//            }
//            .transition(.opacity)
//        }
        EmptyView()
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Todo")
                .font(.title2).bold()
            
            Spacer()
            
            Circle()
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
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
    
    //  MARK: - Function
    
    private func binding(for item: TodoListEntity) -> Binding<TodoListEntity> {
        guard let index = vm.todoListEntitys.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $vm.todoListEntitys[index]
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
                vm.save(date: calendarVM.date)
            }
        }
    }
    
    private func delete(_ model: TodoListEntity) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                vm.deleteTodoListEntity(entity: model, date: calendarVM.date)
            }
        }
    }
    
}
