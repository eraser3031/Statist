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
    
    @Published var progressEntitys: [ProgressEntity] = []
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(date: Date){
        getProgressEntitys(date: date)
        addSubscriber()
    }
    
    func addSubscriber() { }
    
    func getProgressEntitys(date: Date) {
        let request = NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")

//        let filter = NSPredicate(format: "date = %@", date as NSDate)
//        request.predicate = filter
        
        do {
            progressEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching ProgressEntity \(error)")
        }
    }
}
