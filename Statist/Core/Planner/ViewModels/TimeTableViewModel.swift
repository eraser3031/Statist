//
//  TimeTableViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 09/07/2021.
//

import SwiftUI
import Combine
import CoreData

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
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
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
        
        let calendar = Calendar.current
        
        var entitys: [TimetableEntity] = []
        let flattenItems = items.flatMap{ $0 }
        
        func makeEntity(_ i: Int) {
            let newEntity = TimetableEntity(context: manager.context)
            newEntity.kindEntity = flattenItems[i]
            newEntity.id = UUID().uuidString
            newEntity.date = calendar.date(bySettingHour: i/6, minute: i%6, second: 0, of: date)
            newEntity.minute = 10
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
                    entitys[entitys.endIndex - 1].minute += 10
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
        let filter = NSPredicate(format: "date >= %@ AND date <= %@", date as NSDate, date.nextDay() as NSDate)
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
        
        let calendar = Calendar.current
        
        for entity in entitys {
             
            let dateInfo = calendar.dateComponents([.hour, .minute], from: entity.date ?? Date().toDay())
            let hour = dateInfo.hour ?? 0
            print(hour)
            let minute = dateInfo.minute ?? 0
            print(minute)
            for i in 0..<(minute/10) {
                items[hour + i/6][(minute/11) + i%6] = entity.kindEntity
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
        newKindEntity.progressEntitys = []
        newKindEntity.timetableEntitys = []
        newKindEntity.todolistEntitys = []
        manager.save()
    }
    
    func save(date: Date) {
        manager.save()
        getTimeTableEntitys(date: date)
    }

}
