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
    
    @Published var event: TodoEvent?
    @Published var kinds: [KindEntity] = []
    @Published var dates: [Date] = []
    
    @Published var taskCase: TaskCase = .none
    @Published var showKindView = false
    @Published var showKindMenuView = false
    @Published var editingEntity: TodoEntity?
    
    @Published var bindingText: String = ""
    @Published var bindingKind: KindEntity?
    var canTask: Bool {
        !bindingText.isEmpty && bindingKind != nil
    }
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        todoEvent()
        entities()
        kindEntities()
    }
    
    func todoEvent() {
        let request = NSFetchRequest<TodoEvent>(entityName: "TodoEvent")
        do {
            let result = try manager.context.fetch(request).first
            
            guard let result = result else {
                let newEvent = TodoEvent(context: manager.context)
                newEvent.id = UUID().uuidString
                newEvent.dates = [:]
                newEvent.entities = []
                manager.save()
                
                event = newEvent
                dates = []
                
                return
            }
            
            event = result
            if let resultDates = result.dates {
                dates = Array(resultDates.keys)
            } else {
                dates = []
            }
            
        } catch let error {
            print("Error getEvent: \(error)")
        }
    }
    
    func entities() {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        let filter = NSPredicate(format: "date = %@", calendarInfo.date as NSDate)
        request.predicate = filter
        
        do {
            let result = try manager.context.fetch(request)
            let resultHavingKind = result.filter { $0.kindEntity != nil }
            let dict = Dictionary(grouping: resultHavingKind, by: { $0.kindEntity! })

            var temp: [EntityGroupedByKind] = []
            for key in dict.keys {
                temp.append(EntityGroupedByKind(kind: key, entitys: dict[key]?.sorted() ?? []))
            }

            entitysGroupedByKind = temp.sorted()

        } catch let error {
            print("Error Fetching entities: \(error)")
        }
    }
    
    func kindEntities() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        let sort = NSSortDescriptor(keyPath: \KindEntity.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching Kind Entity: \(error)")
        }
        
    }
    
    func addEntity() {
        let newEntity = TodoEntity(context: manager.context)
        newEntity.id = UUID().uuidString
        newEntity.name = bindingText
        newEntity.date = calendarInfo.date
        newEntity.kindEntity = bindingKind
        newEntity.isDone = false
        newEntity.event = event
        
        if var eventDates = event?.dates {
            let itemDate = newEntity.date ?? Date().toDay
            eventDates[itemDate] = (eventDates[itemDate] ?? 0) + 1
            newEntity.event?.dates = eventDates
        }
        
        saveAndLoad()
    }
    
    func updateEntity() {
        if let entity = editingEntity {
            entity.name = bindingText
            entity.kindEntity = bindingKind
        }
        saveAndLoadOnlyEntities()
    }
    
    func deleteEntity(entity: TodoEntity) {
        let entitys = entitysGroupedByKind.map({$0.entitys}).flatMap({$0})
        let model = entitys.first { $0.id == entity.id }
        
        if let model = model {
            manager.context.delete(model)
            saveAndLoad()
        } else {
            print("Error Deleting TodoListEntity")
        }
    }
    
    func toggle(_ entity: TodoEntity) {
        entity.isDone.toggle()
        saveAndLoadOnlyEntities()
    }
    
    func changeTaskToEdit(_ model: TodoEntity) {
        editingEntity = model
        taskCase = .edit
        bindingText = model.name ?? ""
        bindingKind = model.kindEntity
    }
    
    func moveBackDate(_ model: TodoEntity) {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: model.date ?? Date())
        
        let newEntity = TodoEntity(context: manager.context)
        newEntity.id = model.id
        newEntity.name = model.name
        newEntity.date = newDate
        newEntity.kindEntity = model.kindEntity
        newEntity.isDone = model.isDone
        newEntity.event = model.event
        
        deleteEntity(entity: model)
        
        if var eventDates = event?.dates {
            let itemDate = newEntity.date ?? Date().toDay
            eventDates[itemDate] = (eventDates[itemDate] ?? 0) + 1
            newEntity.event?.dates = eventDates
        }
        
        saveAndLoad()
    }
    
    func confirmTask() {
        switch taskCase {
        case .add:
            addEntity()
            clearTask()

        case .edit:
            updateEntity()
            clearTask()
            
        case .none:
            clearTask()
        }
    }
    
    func clearTask() {
        UIApplication.shared.endEditing()
        bindingText = ""
        bindingKind = nil
        editingEntity = nil
        taskCase = .none
    }
    
    func saveAndLoad() {
        manager.save()
        todoEvent()
        entities()
    }
    
    func saveAndLoadOnlyEntities() {
        manager.save()
        entities()
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
