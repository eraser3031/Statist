//
//  StatViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 25/07/2021.
//

import SwiftUI
import Combine
import CoreData

class StatViewModel: ObservableObject {
    @Published var todoEntitys: [TodoListEntity] = []
    @Published var prevWeekTodoEntitys: [TodoListEntity] = []
    var percent: Double {
        calPercent(todoEntitys)
    }
    
    var percentGap: Double {
        calPercent(todoEntitys) - calPercent(prevWeekTodoEntitys)
    }
    
    var countGap: Int {
        calCount(todoEntitys) - calCount(prevWeekTodoEntitys)
    }
    
    @Published var timetableEntityGroups: [[TimetableEntity]] = []
    @Published var result: [TimetableEntity] = []
    @Published var progressEntitys: [ProgressEntity] = []
    
    let manager = CoreDataManager.instance
    
    init() {
        getTodoListEntitys(start: Date().prevWeek().toDay, end: Date().nextDay())
        getPrevTodoListEntitys(today: Date().toDay)
        getTimetableEntityGroups(start: Date().prevWeek().toDay, end: Date().nextDay())
        getProgressEntitys()
    }
    
    private func getTodoListEntitys(start: Date, end: Date) {
        let request = NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
        let filter = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
        request.predicate = filter
        
        do {
            todoEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching TodoListEntitys(by StatViewModel \(error)")
        }
    }
    
    private func getPrevTodoListEntitys(today: Date) {
        let request = NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
        let filter = NSPredicate(format: "date <= %@ AND date >= %@",
                                 today.prevWeek() as NSDate, today.prevWeek().prevWeek() as NSDate)
        
        request.predicate = filter
        
        do {
            prevWeekTodoEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching PrevWeekTodoEntitys(by StatViewModel \(error)")
        }
    }
    
    private func getTimetableEntityGroups(start: Date, end: Date) {
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimetableEntity")
        let filter = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
        let sort = NSSortDescriptor(keyPath: \TimetableEntity.kindEntity, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter
        
        do {
            result = try manager.context.fetch(request) //
            let dict = Dictionary(grouping: result, by: {$0.date?.toDay ?? Date()})
            let dates: [Date] = Calendar.current.generateDates(start: start,
                                                               end: end,
                                                               matching: DateComponents(hour: 0, minute: 0, second: 0))
            timetableEntityGroups = dates.compactMap({dict[$0]})
            print(timetableEntityGroups)
        } catch let error {
            print("Error Fetching TimetableEntitys(by StatViewModel \(error)")
        }
    }
    
    private func getProgressEntitys() {
        
        let request = NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")
//        let filter = NSPredicate(format: "goal != now")
//        request.predicate = filter

        do {
            progressEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching ProgressEntitys(by StatViewModel \(error)")
        }
    }
}
 
// For Extra Method
extension StatViewModel {
    private func calPercent(_ entity: [TodoListEntity]) -> Double {
        let value: Double = entity.reduce(0) { result, entity in
            if entity.isDone {
                return result + 1
            } else {
                return result
            }
        }
        let percent = value / Double(todoEntitys.count) * 100
        return percent
    }
    
    private func calCount(_ entity: [TodoListEntity]) -> Int {
        let count: Int = entity.reduce(0) { result, entity in
            if entity.isDone {
                return result + 1
            } else {
                return result
            }
        }
        return count
    }
}
