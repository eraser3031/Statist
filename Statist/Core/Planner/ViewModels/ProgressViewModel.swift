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
    
    func addProgressPoint(_ entity: ProgressEntity) {
        if entity.isNotFinish {
            let newPoint = ProgressPoint(context: manager.context)
            newPoint.date = Date().toDay()
            newPoint.id = UUID().uuidString
            newPoint.progressEntity = entity
            withAnimation(.spring()) {
                save()
            }
        }
    }
    
    func deleteProgressPoints(_ points: [ProgressPoint]) {
        for point in points {
            manager.context.delete(point)
        }
        withAnimation(.spring()) {
            save()
        }
    }
    
    func save() {
        manager.save()
        getProgressEntitys()
    }
}
