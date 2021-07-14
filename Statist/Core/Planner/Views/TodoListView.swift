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
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(vm.todoListEntitys.indexed(), id: \.element.id) { (index, model) in
                        if vm.sectionIndexes.contains(index) {
                            Text(model.kindEntity?.name ?? "")
                                .font(Font.system(.headline, design: .default).weight(.bold))
                                .foregroundColor(model.kindEntity?.color.toPrimary() ?? Color.primary)
                                .padding(.top, 10)
                        }
                            
                        
                        TodoItemView(model: binding(for: model)){
                            vm.save()
                        }
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            vm.showAddTodoListView = true
                        }
                    }) {
                        HStack(spacing: 2){
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .font(Font.system(.subheadline, design: .default).weight(.bold))
                        .frame(maxWidth: 414)
                        .padding(.vertical, 16)
                        .foregroundColor(Color(.systemBackground))
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.primary)
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(date: Date())
    }
}
