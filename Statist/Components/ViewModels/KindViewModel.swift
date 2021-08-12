//
//  KindViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import Foundation
import CoreData

class KindViewModel: ObservableObject {
    
    @Published var kindEntitys: [KindEntity] = []
    @Published var showAddKindView = false
    
    let manager = CoreDataManager.instance
    
    init(){
        getKindEntitys()
    }
    
    func getKindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kindEntitys = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntity \(error)")
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
        
        save()
    }
    
    func save() {
        manager.save()
        getKindEntitys()
    }
}
