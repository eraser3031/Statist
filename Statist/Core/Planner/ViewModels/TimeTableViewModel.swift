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
    
    @Published var date: Date
    @Published var timeTableEntitys: [TimetableEntity] = []
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        self.date = date
        
        getTimeTableEntitys()
        addSubscriber()
    }
    
    func addSubscriber() {
        $date
            .sink { date in
                self.getTimeTableEntitys()
            }
            .store(in: &cancellables)
    }
    
    func getTimeTableEntitys() {
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimeTableEntity")
        
        let filter = NSPredicate(format: "date = %@", date as NSDate)
        request.predicate = filter
        
        do {
            timeTableEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching TimetableEntity \(error)")
        }
    }
    
}
