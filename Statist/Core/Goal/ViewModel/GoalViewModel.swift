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
}
