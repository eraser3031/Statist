//
//  TodoListViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 09/07/2021.
//

import SwiftUI
import Combine
import CoreData

class TodoListViewModel: ObservableObject {
    
    @Published var date: Date
    @Published var test = false
    @Published var todoListEntitys: [TodoListEntity] = []
    var sectionIndexes: [Int] = []
    
    @Published var showAddTodoView = false
    @Published var showEditTodoView = false
    @Published var editingEntity: TodoListEntity?
    
    let manager = CoreDataManager.instance
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        self.date = date
        getTodoListEntitys()
    }
    
    func addSubscriber() {
        $date
            .sink { date in
                self.getTodoListEntitys()
            }
            .store(in: &cancellables)
    }
    
    func getTodoListEntitys() {
        let request = NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
        let sort = NSSortDescriptor(keyPath: \TodoListEntity.kindEntity, ascending: true)
        request.sortDescriptors = [sort]
//        let filter = NSPredicate(format: "date = %@", date as NSDate)
//        request.predicate = filter
        
        do {
            todoListEntitys = try manager.context.fetch(request)
            
            for (index, item) in todoListEntitys.enumerated() {
                if index == 0 {
                    sectionIndexes = []
                    sectionIndexes.append(index)
                } else {
                    if todoListEntitys[sectionIndexes.last ?? 0].kindEntity != item.kindEntity {
                        sectionIndexes.append(index)
                    }
                }
            }
        } catch let error {
            print("Error Fetching TodoListEntity \(error)")
        }
    }
    
    func getKindEntity(name: String) -> KindEntity? {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        let filter = NSPredicate(format: "name = %@", name)
        request.predicate = filter
        
        do {
            return try manager.context.fetch(request).first
        } catch let error {
            print("Error Fetching Kind Entity: \(error)")
        }
        
        return nil
    }
    
//    func addTodoListEntity(_ name: String, kind kindName: String) {
//        let newTodoListEntity = TodoListEntity(context: manager.context)
//        newTodoListEntity.name = name
//        newTodoListEntity.id = UUID().uuidString
//        newTodoListEntity.isDone = false
//        newTodoListEntity.date = Date()
//        
//        newTodoListEntity.kindEntity = getKindEntity(name: "guitar")
//        save()
//    }
    
    func deleteTodoListEntity(entity: TodoListEntity) {
        let model = todoListEntitys.first { $0.id == entity.id }
        
        if let model = model {
            manager.context.delete(model)
            save()
        } else {
            print("Error Deleting TodoListEntity")
        }
    }
    
    func addKindEntity(_ name: String, color: ColorKind) {
        
        let newKindEntity = KindEntity(context: manager.context)
        newKindEntity.name = name
        newKindEntity.id = UUID().uuidString
        newKindEntity.colorKindID = color.id
        
        newKindEntity.todoListEntitys = []
        newKindEntity.timeTableEntitys = []
        newKindEntity.progressEntitys = []
        
        manager.save()
    }
    
    func save() {
        manager.save()
        getTodoListEntitys()
    }
}



