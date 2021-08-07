//
//  TodoViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 09/07/2021.
//

import SwiftUI
import Combine
import CoreData

class TodoViewModel: ObservableObject {
    
    @Published var entitysGroupedByKind: [EntityGroupedByKind] = []
    @Published var calendarInfo = CalendarInfo()
    
    @Published var showAddTodoView = false
    @Published var showEditTodoView = false
    @Published var editingEntity: TodoListEntity?
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        entitys()
    }
    
    func entitys() {
        let request = NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
        let sort = NSSortDescriptor(keyPath: \TodoListEntity.kindEntity, ascending: true)
        request.sortDescriptors = [sort]
        let filter = NSPredicate(format: "date = %@", calendarInfo.date as NSDate)
        request.predicate = filter
        
        do {
            let result = try manager.context.fetch(request)
            print(calendarInfo.date)
            let entitys = result.filter { $0.kindEntity != nil }
            let dict = Dictionary(grouping: entitys, by: { $0.kindEntity! })
            
            var temp: [EntityGroupedByKind] = []
            for key in dict.keys {
                temp.append(EntityGroupedByKind(kind: key, entitys: dict[key]?.sorted() ?? []))
            }
            
            entitysGroupedByKind = temp.sorted()
//            print(entitysGroupedByKind)
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
    
    func toggle(_ entity: TodoListEntity) {
        entity.isDone.toggle()
        save()
    }
    
    private func deleteEntity(entity: TodoListEntity) {
        let entitys = entitysGroupedByKind.map({$0.entitys}).flatMap({$0})
        let model = entitys.first { $0.id == entity.id }
        
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
        newKindEntity.progressEntitys = []
        newKindEntity.timetableEntitys = []
        newKindEntity.todolistEntitys = []
        manager.save()
    }
    
    func edit(_ model: TodoListEntity) {
        withAnimation(.spring()) {
            editingEntity = model
        }
        showEditTodoView = true
    }
    
    func moveBackDate(_ model: TodoListEntity) {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: model.date ?? Date())
        model.date = newDate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                self.save()
            }
        }
    }
    
    func deleteEntityAsync(_ model: TodoListEntity) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                self.deleteEntity(entity: model)
            }
        }
    }
    
    func save() {
        manager.save()
        entitys()
    }
}

struct EntityGroupedByKind: Identifiable, Comparable {
    static func < (lhs: EntityGroupedByKind, rhs: EntityGroupedByKind) -> Bool {
        (lhs.kindEntity.name ?? "") > (rhs.kindEntity.name ?? "")
    }
    
    let id: String
    var kindEntity: KindEntity
    var entitys: [TodoListEntity]
    
    init(kind: KindEntity, entitys: [TodoListEntity]) {
        self.id = kind.id ?? ""
        self.kindEntity = kind
        self.entitys = entitys
    }
}

