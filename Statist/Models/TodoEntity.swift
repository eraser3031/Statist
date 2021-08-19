//
//  TodoEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 20/08/2021.
//

import UIKit
import CoreData

extension TodoEntity: Comparable {
    
//    public override func awakeFromInsert() {
//        super.awakeFromInsert()
//        
//        guard var eventDates = event?.dates else { return }
//        let itemDate = self.date ?? Date().toDay
//        eventDates[itemDate] = (eventDates[itemDate] ?? 0) + 1
//        
//        self.event?.dates = eventDates
//        CoreDataManager.instance.save()
//        print("awake:")
//        print(eventDates)
//    }
    
    public override func prepareForDeletion() {
        super.prepareForDeletion()
        
        guard var eventDates = event?.dates else { return }
        let itemDate = self.date ?? Date().toDay
        eventDates[itemDate] = (eventDates[itemDate] ?? 0) - 1
        
        if (eventDates[itemDate] ?? 0) <= 0 {
            eventDates[itemDate] = nil
        }
        
        self.event?.dates = eventDates
        CoreDataManager.instance.save()
        print("deletion:")
        print(eventDates)
    }
    
    public static func < (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        (lhs.name ?? "") > (rhs.name ?? "")
    }
}
