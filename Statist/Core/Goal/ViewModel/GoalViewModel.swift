//
//  GoalViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import Foundation
import CoreData
import SwiftUI

enum ValidCase: String {
    
    var text: String {
        switch self {
        case .overlayName:
            return "Name overlaps with another goal."
        case .emptyName:
            return "Name is empty"
        case .emptyKind:
            return "Kind is empty"
        case .emptyGoal:
            return "Count is empty"
        case .goalLessThanNow:
            return "Count is lower than your now count"
        case .clear:
            return "clear"
        }
    }
    
    case overlayName
    case emptyName
    case emptyKind
    case emptyGoal
    case goalLessThanNow
    case clear
}

class GoalViewModel: ObservableObject {
    @Published var goals: [GoalEntity] = []
    @Published var goalCase: GoalCase = .recent
    @Published var sortCase: SortCase = .name
    
    @Published var onEntity: GoalEntity?
    
    @Published var taskCase: TaskCase = .none {
        didSet {
            showTaskView = taskCase != .none ? true : false
        }
    }
    
    @Published var selectedEntity: GoalEntity?
    
    @Published var showTaskView = false
    @Published var editingEntity: GoalEntity?
    
    @Published var showKindView = false
    @Published var kinds: [KindEntity] = []
    
    @Published var nameForTask = ""
    @Published var endDateForTask = Date().toDay.nextDay()
    @Published var kindForTask: KindEntity?
    @Published var goalForTask = ""
    
    var isValid: ValidCase {
        var cases: [ValidCase] = []
        if nameForTask.isEmpty {
            cases.append(ValidCase.emptyName)
        }
        
        if kindForTask == nil {
            cases.append(ValidCase.emptyKind)
        }
        
        if goalForTask.isEmpty || (Int(goalForTask) ?? 0) < 1 {
            cases.append(ValidCase.emptyGoal)
        }
        
        if let editingEntity = editingEntity {
            if (Int(goalForTask) ?? 0) < (editingEntity.times?.count ?? 0) {
                cases.append(ValidCase.goalLessThanNow)
            }
        }
        
        return cases.first ?? .clear
    }
    
    let manager = CoreDataManager.instance
    
    init(){
        entities()
        kindEntities()
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
        let newEntity = GoalEntity(context: manager.context)
        newEntity.id = UUID().uuidString
        newEntity.name = nameForTask
        newEntity.endDate = endDateForTask
        newEntity.goal = Int16(goalForTask) ?? 0
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
        editingEntity.goal = Int16(goalForTask) ?? 0
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
    
    func confirmTask() {
        switch taskCase {
        case .edit:
            updateEntity()
            taskCase = .none
        case .add:
            addEntity()
            taskCase = .none
        case .none:
            print("Impossible Error: confirmTask()")
            taskCase = .none
        }
    }
    
    func initForTask() {
        switch taskCase {
        case .none:
            print("Impossible Error: initForTask()")
            
        case .add:
            nameForTask = ""
            endDateForTask = Date().toDay.nextDay()
            kindForTask = nil
            goalForTask = ""
            
        case .edit:
            guard let editingEntity = editingEntity else {
                return
            }
            nameForTask = editingEntity.name ?? ""
            endDateForTask = editingEntity.endDate ?? Date().toDay.nextDay()
            kindForTask = editingEntity.kindEntity
            goalForTask = String(editingEntity.goal)
        }
    }
    
    func clearForTask() {
        nameForTask = ""
        endDateForTask = Date().toDay.nextDay()
        kindForTask = nil
        goalForTask = ""
        editingEntity = nil
    }
    
    func proceed() {
        guard let selectedEntity = selectedEntity else {
            return
        }

        if (selectedEntity.times?.count ?? 0) < Int(selectedEntity.goal) {
            selectedEntity.times?.append(Date().toDay)
            saveAndLoad()
        }
    }
    
    func backward() {
        guard let selectedEntity = selectedEntity else {
            return
        }
        
        let newTimes = selectedEntity.times?.filter({$0 != Date().toDay})
        selectedEntity.times = newTimes
        saveAndLoad()
    }
}
