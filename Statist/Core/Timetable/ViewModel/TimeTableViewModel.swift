//
//  TimeTableViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 09/07/2021.
//

import SwiftUI
import Combine
import CoreData

class NewTimetableViewModel: ObservableObject {
    
    @Published var calendarInfo = CalendarInfo()
    
    @Published var timetables: [TimetableEntity] = []
    @Published var selectedKind: KindEntity?
    @Published var items: [[KindEntity?]] = []
    @Published var isModified = false
    
    @Published var kinds: [KindEntity] = []
    @Published var showKindView = false
    @Published var showKindMenuView = false
    
    @Published var event: TimetableEvent?
    @Published var dates: [Date] = []
    
    let manager = CoreDataManager.instance
    
    init(){
        timetableEvent()
        entities()
        kindEntities()
    }
    
    func timetableEvent() {
        let request = NSFetchRequest<TimetableEvent>(entityName: "TimetableEvent")
        
        do {
            let result = try manager.context.fetch(request).first
            
            guard let result = result else {
                let newEvent = TimetableEvent(context: manager.context)
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
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimetableEntity")
        let filter = NSPredicate(format: "date == %@", calendarInfo.date as NSDate)
        request.predicate = filter
        
        do {
            timetables = try manager.context.fetch(request)
            print("from entities")
            print(timetables)
            items = decodeToItems(entitys: timetables)
        } catch let error {
            print("Error Fetching TimetableEntity \(error)")
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
    
    private func encodeToTimetableEntitys(items: [[KindEntity?]]) -> [TimetableEntity] {
        
        var entities: [TimetableEntity] = []
        let flattenItems = items.flatMap{ $0 }
        
        func makeEntity(_ i: Int) {
            let newEntity = TimetableEntity(context: manager.context)
            newEntity.kindEntity = flattenItems[i]
            newEntity.id = UUID().uuidString
            newEntity.date = calendarInfo.date
            newEntity.hour = Int16(i / 6)
            newEntity.minute = Int16( (i % 6) * 10 )
            newEntity.duration = 10
            entities.append(newEntity)
        }
        
        for i in 0..<flattenItems.count-1 {
            if i == 0 {
                if flattenItems[i] != nil {
                    makeEntity(i)
                }
            }
            
            if flattenItems[i] == flattenItems[i+1] {
                if flattenItems[i+1] != nil {
                    entities[entities.endIndex - 1].duration += 10
                }
            } else {
                if flattenItems[i+1] != nil {
                    makeEntity(i+1)
                }
            }
        }
        
        return entities
    }
    
    private func decodeToItems(entitys: [TimetableEntity]) -> [[KindEntity?]] {
        
        var items = [[KindEntity?]](repeating: [KindEntity?](repeating: nil, count: 6), count: 24)
        
        for entity in entitys {

            let hour = Int(entity.hour)
            let minute = Int(entity.minute)
            
            for i in 0..<(entity.duration/10) {
                items[hour + (minute/10 + Int(i))/6][(minute/10 + Int(i))%6] = entity.kindEntity
            }
        }
        
        return items
    }
    
    func changeItemsByHour(_ hour: Int) -> Void {
        let oldItems = items[hour]
        if oldItems.contains(where: { $0 == nil }) {
            let newItems = oldItems.map{ _ in return selectedKind }
            items[hour] = newItems
        } else {
            items[hour] = [KindEntity?](repeating: nil, count: 6)
        }
        
        if !isModified {
            isModified = true
        }
    }
    
    func removeEntitys() {
        for timetable in timetables {
            manager.context.delete(timetable)
        }
    }
    
    func saveAndLoad() {
        removeEntitys()
        let result = encodeToTimetableEntitys(items: items)
        
        if result.isEmpty == false {
            if var eventDates = event?.dates {
                let itemDate = calendarInfo.date
                eventDates[itemDate] = 1
                event?.dates = eventDates
                manager.save()
            }
        } else {
            event?.dates?[calendarInfo.date] = nil
            manager.save()
        }
        
        manager.save()
        timetableEvent()
        entities()
        
        print(event?.dates)
    }
}
