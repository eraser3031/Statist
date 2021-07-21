//
//  AddProgressViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 21/07/2021.
//

import Foundation
import CoreData

class AddProgressViewModel: ObservableObject {
    @Published var name = ""
    @Published var goal: Float = 0
    @Published var selectedKind: KindEntity?
    
    @Published var kinds: [KindEntity] = []
    @Published var showAddKindView: Bool = false
    
    let manager = CoreDataManager.instance
    
    init() {
        getKindEntitys()
    }
    
    func isDisabled() -> Bool {
        return name == "" || selectedKind == nil || goal == 0
    }
    
    func getKindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntitys \(error)")
        }
    }
    
    func addProgressEntity() {
        let newEntity = ProgressEntity(context: manager.context)
        newEntity.goal = Int16(goal)
        newEntity.progressPoints = nil
        newEntity.kindEntity = selectedKind
        newEntity.name = name
        newEntity.id = UUID().uuidString
        manager.save()
    }
    
    func save() {
        manager.save()
        getKindEntitys()
    }
}
