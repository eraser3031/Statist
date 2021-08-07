//
//  TodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI

struct TodoView: View {
    
    @StateObject var vm: TodoViewModel
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: TodoViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            GroupedCalendarView(info: $vm.calendarInfo)
                .shadow(color: Color.theme.shadowColor.opacity(0.14), radius: 14, x: 0.0, y: 8)
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24){
                    if vm.entitysGroupedByKind.isEmpty {
                        empty
                    } else {
                        todoList
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .onChange(of: vm.calendarInfo.date) { _ in
            vm.entitys()
        }
    }
    
    //  MARK: - Components
    
    private var todoList: some View {
        ForEach(vm.entitysGroupedByKind, id: \.id) { groupedByKind in
            
            let entitys = groupedByKind.entitys
            let kind = groupedByKind.kindEntity
            let name = kind.name ?? ""
            let primaryColor = kind.color.toPrimary()
            
            VStack(alignment: .leading, spacing: 10){
                HStack(spacing: 8) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 12, height: 12)
                    
                    Text(name)
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                }
                .padding(.vertical, 10)
                
                VStack(spacing: 12) {
                    ForEach(entitys) { entity in
                        NewTodoItemView(entity, vm: vm)
                    }
                }
            }
            
        }
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
    
//    private func binding(for item: TodoListEntity) -> Binding<TodoListEntity> {
//        guard let index = vm.todoListEntitys.firstIndex(where: { $0.id == item.id }) else {
//            fatalError("Can't find scrum in array")
//        }
//        return $vm.todoListEntitys[index]
//    }
}
