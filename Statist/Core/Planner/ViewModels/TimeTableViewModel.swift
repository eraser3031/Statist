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
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        getTimeTableEntitys(date: date)
        addSubscriber()
    }
    
    func addSubscriber() { }
    
    func getTimeTableEntitys(date: Date) {
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimeTableEntity")
        
//        let filter = NSPredicate(format: "date = %@", date as NSDate)
//        request.predicate = filter
        
        do {
            timeTableEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching TimetableEntity \(error)")
        }
    }
    
}
