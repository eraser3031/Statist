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
    @Published var showAddProgressView = false
    @Published var showEditProgressView = false
    @Published var editingEntity: ProgressEntity?
    
    let manager = CoreDataManager.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        getProgressEntitys()
        addSubscriber()
    }
    
    func addSubscriber() { }
    
    func getProgressEntitys() {
        let request = NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")
        
        do {
            progressEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching ProgressEntity \(error)")
        }
    }
    
    func deleteProgressEntity(entity: ProgressEntity) {
        let model = progressEntitys.first { $0.id == entity.id }
        
        if let model = model {
            manager.context.delete(model)
            save()
        } else {
            print("Error Deleting TodoListEntity")
        }
    }
    
    func save() {
        manager.save()
        getProgressEntitys()
    }
}
