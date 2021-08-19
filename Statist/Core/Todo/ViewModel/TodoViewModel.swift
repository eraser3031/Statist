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
    
    @Published var kinds: [KindEntity] = []
    @Published var dates: [Date] = []
    
    @Published var taskCase: TaskCase = .none
    @Published var showKindView = false
    @Published var showMenuKindView = false
    @Published var editingEntity: TodoEntity?
    
    @Published var text: String = ""
    @Published var kind: KindEntity?
    var canTask: Bool {
        !text.isEmpty && kind != nil
    }
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        entitys()
        kindEntitys()
    }
    
    func entitys() {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        let sort = NSSortDescriptor(keyPath: \TodoEntity.kindEntity, ascending: true)
        request.sortDescriptors = [sort]
        let filter = NSPredicate(format: "date = %@", calendarInfo.date as NSDate)
        request.predicate = filter
        
//        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: request) { [weak self] result in
//            guard let self = self, let todoes = result.finalResult else {
//                return
//            }
//            
//            let entitys = todoes.filter { $0.kindEntity != nil }
//            let dict = Dictionary(grouping: entitys, by: { $0.kindEntity! })
//            
//            var temp: [EntityGroupedByKind] = []
//            for key in dict.keys {
//                temp.append(EntityGroupedByKind(kind: key, entitys: dict[key]?.sorted() ?? []))
//            }
//            
//            DispatchQueue.main.async {
//                self.entitysGroupedByKind = temp.sorted()
//            }
//        }
//        
//        do {
//            let backgroundContext = manager.container.newBackgroundContext()
//            try backgroundContext.execute(asyncFetch)
//        } catch let error {
//            print("Error Fetching TodoListEntity \(error)")
//        }
        
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
            print(entitysGroupedByKind)
        } catch let error {
            print("Error Fetching TodoListEntity \(error)")
        }
    }
    
    func kindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        let sort = NSSortDescriptor(keyPath: \KindEntity.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching Kind Entity: \(error)")
        }
        
    }
    
    func datesByEvents() {
        let request = NSFetchRequest<TodoEvent>(entityName: "TodoEvent")
        do {
            let result = try manager.context.fetch(request)
            dates = result.map{ $0.date }
        } catch let error {
            print("Error Fetching Todo Event Entity: \(error)")
        }
    }
    
    func checkEvent() {
        if entitysGroupedByKind.isEmpty {
            deleteEvent()
        } else {
            addEvent(calendarInfo.date)
        }
    }
    
    func addEvent(_ date: Date) {
        let result = events?.dates?.first { $0 == date}
        if result == nil {
            var newDates = events?.dates ?? []
            newDates.append(date)
            events?.dates = newDates
        }
    }
    
    func deleteEvent() {
        let index = events?.dates?.firstIndex { $0 == calendarInfo.date}
        if let index = index {
            var newDates = events?.dates ?? []
            newDates.remove(at: index) //
            events?.dates = newDates
        }
    }
    
    func addTodoEntity() {
        let newEntity = TodoEntity(context: manager.context)
        newEntity.id = UUID().uuidString
        newEntity.name = text
        newEntity.date = calendarInfo.date
        newEntity.kindEntity = kind
        newEntity.isDone = false
        withAnimation(.closeCard) {
            save()
        }
    }
    
    func editTodoEntity() {
        if let entity = editingEntity {
            entity.name = text
            entity.kindEntity = kind
        }
        withAnimation(.spring()) {
            save()
        }
    }
    
    func deleteTodoEntity(entity: TodoEntity) {
        let entitys = entitysGroupedByKind.map({$0.entitys}).flatMap({$0})
        let model = entitys.first { $0.id == entity.id }
        
        if let model = model {
            manager.context.delete(model)
            withAnimation(.closeCard){
                save()
            }
        } else {
            print("Error Deleting TodoListEntity")
        }
    }
    
    func toggle(_ entity: TodoEntity) {
        entity.isDone.toggle()
        save()
    }
    
    func changeTaskToEdit(_ model: TodoEntity) {
        withAnimation(.spring()) {
            editingEntity = model
            taskCase = .edit
            text = model.name ?? ""
            kind = model.kindEntity
        }
    }
    
    func moveBackDate(_ model: TodoEntity) {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: model.date ?? Date())
        model.date = newDate
        withAnimation(.spring()) {
            addEvent(newDate ?? Date().toDay)
            self.save()
        }
    }
    
    func clearTask() {
        UIApplication.shared.endEditing()
        text = ""
        kind = nil
        editingEntity = nil
        taskCase = .none
    }
    
    func save() {
        manager.save()
        entitys()
        
        checkEvent()
        manager.save()
        events = todoEvents()
    }
}

struct EntityGroupedByKind: Identifiable, Comparable {
    static func < (lhs: EntityGroupedByKind, rhs: EntityGroupedByKind) -> Bool {
        (lhs.kindEntity.name ?? "") > (rhs.kindEntity.name ?? "")
    }
    
    let id: String
    var kindEntity: KindEntity
    var entitys: [TodoEntity]
    
    init(kind: KindEntity, entitys: [TodoEntity]) {
        self.id = kind.id ?? ""
        self.kindEntity = kind
        self.entitys = entitys
    }
}

enum TaskCase: String {
    case edit
    case add
    case none
}
