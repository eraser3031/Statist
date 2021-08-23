//
//  GoalViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import Foundation
import CoreData

class GoalViewModel: ObservableObject {
    @Published var goals: [GoalEntity] = []
    @Published var goalCase: GoalCase = .recent
    @Published var sortCase: SortCase = .name
    
    @Published var onEntity: GoalEntity?
    
    @Published var taskCase: TaskCase = .none
    @Published var editingEntity: GoalEntity?
    
    @Published var nameForTask = ""
    @Published var endDateForTask = Date().toDay
    @Published var kindForTask: KindEntity?
    @Published var goalForTask = 0
    
    
    
    let manager = CoreDataManager.instance
    
    init(){
        entities()
    }
    
    func entities() {
        let request = NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
        var sort = NSSortDescriptor(keyPath: \GoalEntity.name, ascending: true)
        if sortCase == .date {
            sort = NSSortDescriptor(keyPath: \GoalEntity.endDate, ascending: true)
        }
//        else if sortCase == .percent {
//            sort = NSSortDescriptor(keyPath: \GoalEntity.percent, ascending: true)
//        }
        
        let filter = NSPredicate(format: goalCase == .recent ? "endDate > %@" : "endDate < %@" , Date().toDay as NSDate)
        
        request.sortDescriptors = [sort]
        request.predicate = filter
        
        do {
            goals = try manager.context.fetch(request)
            print("hi?")
        } catch let error {
            print("Error getEvent: \(error)")
        }
    }
    
    func addEntity() {
        let newEntity = GoalEntity(context: manager.context)
        newEntity.id = UUID().uuidString
        newEntity.name = nameForTask
        newEntity.endDate = endDateForTask
        newEntity.kindEntity = kindForTask
        newEntity.times = []
        
        saveAndLoad()
    }
    
    func updateEntity() {
        guard let editingEntity = editingEntity else {
            return
        }
        
        editingEntity.name = nameForTask
        editingEntity.endDate = endDateForTask
        editingEntity.kindEntity = kindForTask
        
        saveAndLoad()
    }
    
    func deleteEntity(entity: GoalEntity) {
        manager.context.delete(entity)
        saveAndLoad()
    }
    
    func saveAndLoad() {
        manager.save()
        entities()
    }
    
    func clearForTask() {
        switch taskCase {
        case .none:
            nameForTask = ""
            endDateForTask = Date().toDay
            kindForTask = nil
            goalForTask = 0
            
        case .add:
            nameForTask = ""
            endDateForTask = Date().toDay
            kindForTask = nil
            goalForTask = 0
            
        case .edit:
            guard let editingEntity = editingEntity else {
                return
            }

            nameForTask = editingEntity.name ?? ""
            endDateForTask = editingEntity.endDate ?? Date().toDay
            kindForTask = editingEntity.kindEntity
            goalForTask = Int(editingEntity.goal)
        }
    }
}
