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
    
    @Published var kinds: [KindEntity] = []
    @Published var showKindView = false
    @Published var showKindMenuView = false
    
    @Published var events: TimetableEvent?
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        entitys()
        kindEntitys()
        addSubscriber()
    }
    
    func addSubscriber() {
        $items
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(encodeToTimetableEntitys)
            .sink { [weak self] timetables in
                guard let self = self else { return }
                self.removeEntitys()
                self.timetables = timetables
                self.manager.save()
            }
            .store(in: &cancellables)
    }
    
    func entitys() {
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimetableEntity")
        let filter = NSPredicate(format: "date == %@", calendarInfo.date as NSDate)
        request.predicate = filter
        
        do {
            timetables = try manager.context.fetch(request)
            items = decodeToItems(entitys: timetables)
        } catch let error {
            print("Error Fetching TimetableEntity \(error)")
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
    
    private func encodeToTimetableEntitys(items: [[KindEntity?]]) -> [TimetableEntity] {
        
        var entitys: [TimetableEntity] = []
        let flattenItems = items.flatMap{ $0 }
        
        func makeEntity(_ i: Int) {
            let newEntity = TimetableEntity(context: manager.context)
            newEntity.kindEntity = flattenItems[i]
            newEntity.id = UUID().uuidString
            newEntity.date = calendarInfo.date
            newEntity.hour = Int16(i / 6)
            newEntity.minute = Int16( (i % 6) * 10 )
            newEntity.duration = 10
            entitys.append(newEntity)
        }
        
        for i in 0..<flattenItems.count-1 {
            if i == 0 {
                if flattenItems[i] != nil {
                    makeEntity(i)
                }
            }
            
            if flattenItems[i] == flattenItems[i+1] {
                if flattenItems[i+1] != nil {
                    entitys[entitys.endIndex - 1].duration += 10
                }
            } else {
                if flattenItems[i+1] != nil {
                    makeEntity(i+1)
                }
            }
        }
        
        return entitys
    }
    
    private func decodeToItems(entitys: [TimetableEntity]) -> [[KindEntity?]] {
        
        var items = [[KindEntity?]](repeating: [KindEntity?](repeating: nil, count: 6), count: 24)
        
        for entity in entitys {

            let hour = Int(entity.hour)
            let minute = Int(entity.minute)
            
            for i in 0..<(entity.duration/10) {
                items[hour + Int(i)/6][(minute/10 + Int(i))%6] = entity.kindEntity
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
    }
    
    func removeEntitys() {
        for timetable in timetables {
            manager.context.delete(timetable)
        }
    }
}

class TimeTableViewModel: ObservableObject {
    
    @Published var timeTableEntitys: [TimetableEntity] = []
    @Published var selectedKind: KindEntity?
    @Published var items: [[KindEntity?]] = []
    
    @Published var kinds: [KindEntity] = []
    @Published var showAddKindView = false
    
    private var date: Date = Date()
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        self.date = date
        getTimeTableEntitys(date: date)
        getKindEntitys()
        addSubscriber()
    }
    
    func addSubscriber() {
        $items
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(encodeToTimetableEntitys)
            .sink { [weak self] entitys in
                guard let self = self else { return }
                self.removeTimetableEntitys(date: self.date)
                self.timeTableEntitys = entitys
                self.manager.save()
            }
            .store(in: &cancellables)
    }
    
    private func encodeToTimetableEntitys(items: [[KindEntity?]]) -> [TimetableEntity] {
        
        var entitys: [TimetableEntity] = []
        let flattenItems = items.flatMap{ $0 }
        
        func makeEntity(_ i: Int) {
            let newEntity = TimetableEntity(context: manager.context)
            newEntity.kindEntity = flattenItems[i]
            newEntity.id = UUID().uuidString
            newEntity.date = date
            newEntity.hour = Int16(i / 6)
            newEntity.minute = Int16( (i % 6) * 10 )
            newEntity.duration = 10
            entitys.append(newEntity)
        }
        
        for i in 0..<flattenItems.count-1 {
            if i == 0 {
                if flattenItems[i] != nil {
                    makeEntity(i)
                }
            }
            
            if flattenItems[i] == flattenItems[i+1] {
                if flattenItems[i+1] != nil {
                    entitys[entitys.endIndex - 1].duration += 10
                }
            } else {
                if flattenItems[i+1] != nil {
                    makeEntity(i+1)
                }
            }
        }
        
        return entitys
    }
    
    func tapColumn(_ index: Int) -> Void {
        let oldItems = items[index]
        if oldItems.contains(where: { $0 == nil }) {
            let newItems = oldItems.map{ _ in return selectedKind }
            items[index] = newItems
        } else {
            items[index] = [KindEntity?](repeating: nil, count: 6)
        }
    }
    
    func getTimeTableEntitys(date: Date) {
        self.date = date
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimetableEntity")
        let filter = NSPredicate(format: "date == %@", date as NSDate)
        request.predicate = filter
        
        do {
            timeTableEntitys = try manager.context.fetch(request)
            items = decodeToItems(entitys: timeTableEntitys)
        } catch let error {
            print("Error Fetching TimetableEntity \(error)")
        }
    }
    
    func decodeToItems(entitys: [TimetableEntity]) -> [[KindEntity?]] {
        
        var items = [[KindEntity?]](repeating: [KindEntity?](repeating: nil, count: 6), count: 24)
        
        for entity in entitys {

            let hour = Int(entity.hour)
            let minute = Int(entity.minute)
            
            for i in 0..<(entity.duration/10) {
                items[hour + Int(i)/6][(minute/10 + Int(i))%6] = entity.kindEntity
            }
        }
        
        return items
    }
    
    func removeTimetableEntitys(date: Date) {
        for entity in timeTableEntitys {
            manager.context.delete(entity)
        }
    }
    
    func getKindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntitys \(error)")
        }
    }

    func addKindEntity(_ name: String, color: ColorKind) {
        
        let newKindEntity = KindEntity(context: manager.context)
        newKindEntity.name = name
        newKindEntity.id = UUID().uuidString
        newKindEntity.colorKindID = color.id
        
        newKindEntity.progressEntities = []
        newKindEntity.timetableEntities = []
        newKindEntity.todoEntities = []
        manager.save()
    }
    
    func save(date: Date) {
        manager.save()
        getTimeTableEntitys(date: date)
    }

}
