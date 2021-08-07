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
                    
                    Label("Add new Todo", systemImage: "plus")
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .padding(16)
                        .frame(maxWidth: 400, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.systemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.theme.dividerColor)
                        )
                        .shadow(color: Color.theme.shadowColor.opacity(0.14), radius: 14, x: 0.0, y: 8)
                        .padding(.vertical, !vm.entitysGroupedByKind.isEmpty ? 24 : 4)
                }
                .padding(.horizontal, 16)
            }
        }
        .onChange(of: vm.calendarInfo.date) { _ in
            withAnimation(.spring()){
                vm.entitys()
            }
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
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.theme.subBackgroundColor)
            .frame(height: 300)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.theme.dividerColor,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [8]))
                    .padding(1)
            )
            .overlay(
                VStack(spacing: 4) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.title2)
                    
                    Text("Todo is empty")
                        .font(.footnote)
                }
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
