//
//  StatViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 25/07/2021.
//

import Foundation
import CoreData

class StatViewModel: ObservableObject {
    @Published var todoEntitys: [TodoListEntity] = []
    var percent: Int {
        let value: Double = todoEntitys.reduce(0) { result, entity in
            if entity.isDone {
                return result + 1
            } else {
                return result
            }
        }
        let percent = value / Double(todoEntitys.count) * 100
        return Int(percent)
    }
    
    @Published var timetableEntityGroups: [[TimetableEntity]] = []
    
    @Published var progressEntitys: [ProgressEntity] = []
    
    let manager = CoreDataManager.instance
    
    init() {
        getTodoListEntitys(start: Date().toDay(), end: Date().prevWeek().toDay())
        getTimetableEntityGroups()
        getProgressEntitys()
    }
    
    private func getTodoListEntitys(start: Date, end: Date) {
        let request = NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
        let filter = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
        request.predicate = filter
        
        do {
            todoEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching TodoListEntitys(by StatViewModel) \(error)")
        }
    }
    
    
    
    private func getTimetableEntityGroups() {
        
    }
    
    private func getProgressEntitys() {
        
        let request = NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")

        do {
            progressEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching ProgressEntitys(by StatViewModel \(error)")
        }
    }
}
