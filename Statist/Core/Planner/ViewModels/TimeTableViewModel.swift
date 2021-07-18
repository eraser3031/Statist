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
    @Published var items: [[Kind?]] = []
    
    @Published var kinds: [KindEntity] = []
    @Published var showAddKindView = false
    
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        getTimeTableEntitys(date: date)
        getKindEntitys()
        addSubscriber()
        items = [[Kind?]](repeating: [Kind?](repeating: nil, count: 7), count: 24)
    }
    
    func addSubscriber() {
        $items
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .map(encodeToTimetableEntitys)
            .sink { entitys in
                <#code#>
            }
    }
    
    private func encodeToTimetableEntitys(items: [[Kind?]]) -> [TimetableEntity] {
        
        var entitys: [TimetableEntity] = []
        let flattenItems = items.flatMap{ $0 }
        
        var lastItemID: String = ""
        for (index, item) in flattenItems.enumerated() {
            
            
            
        }
        
        return entitys
    }
    
    func decodeToKind() -> Kind? {
        if let kind = selectedKind {
            return Kind(id: kind.id ?? "", name: kind.name ?? "", color: kind.color)
        }
        
        return nil
    }
    
    func tapColumn(_ index: Int) -> Void {
        let oldItems = items[index]
        if oldItems.contains(where: { $0 == nil }) {
            let newItems = oldItems.map{ selectedKind == nil ? nil : Kind(id: $0?.id ?? "", name: $0?.name ?? "", color: selectedKind!.color) }
            items[index] = newItems
        } else {
            items[index] = [Kind?](repeating: nil, count: 7)
        }
    }
    
    func getTimeTableEntitys(date: Date) {
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimetableEntity")
        let filter = NSPredicate(format: "startedDate >= %@ AND endedDate <= %@", date as NSDate, date.nextDay() as NSDate)
        request.predicate = filter
        
        do {
            timeTableEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching TimetableEntity \(error)")
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
        
        newKindEntity.todoListEntitys = []
        newKindEntity.timeTableEntitys = []
        newKindEntity.progressEntitys = []
        
        manager.save()
    }
    
    func save(date: Date) {
        manager.save()
        getTimeTableEntitys(date: date)
    }

}
