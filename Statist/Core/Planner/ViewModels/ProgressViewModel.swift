//
//  ProgressViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 09/07/2021.
//

import SwiftUI
import Combine
import CoreData

class ProgressViewModel: ObservableObject {
    
    @Published var date: Date
    @Published var progressEntitys: [ProgressEntity] = []
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        self.date = date
        getProgressEntitys()
    }
    
    func addSubscriber() {
        $date
            .sink { date in
                self.getProgressEntitys()
            }
            .store(in: &cancellables)
    }
    
    func getProgressEntitys() {
        let request = NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")

        let filter = NSPredicate(format: "date = %@", date as NSDate)
        request.predicate = filter
        
        do {
            progressEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching ProgressEntity \(error)")
        }
    }
}
