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
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(date: Date())
    }
}
