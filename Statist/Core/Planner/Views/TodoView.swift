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
    
    private func binding(for item: TodoListEntity) -> Binding<TodoListEntity> {
        guard let index = vm.todoListEntitys.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $vm.todoListEntitys[index]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            GroupedCalendarView(vm: calendarVM)
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            
            Rectangle()
                .fill(.orange)
        }
        .background(GeometryGetter(rect: $calendarVM.rect))
//        .onReceive(environment.$date) { date in
//            withAnimation(.spring()) {
//                vm.getTodoListEntitys(date: date)
//            }
//        }
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
}
