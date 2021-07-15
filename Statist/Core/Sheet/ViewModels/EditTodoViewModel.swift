//
//  EditTodoViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 15/07/2021.
//

import Foundation
import CoreData

class EditTodoViewModel: ObservableObject {
    
    @Published var name: String
    @Published var date: Date
    @Published var kind: KindEntity?
    @Published var kinds: [KindEntity] = []
    @Published var showAddKindView = false
    var entity: TodoListEntity?
    
    let manager = CoreDataManager.instance
    
    init(entity: TodoListEntity?) {
        self.entity = entity
        self.name = entity?.name ?? ""
        self.date = entity?.date ?? Date()
        self.kind = entity?.kindEntity
        getKindEntitys()
    }
    
    func updateEntity() {
        if let entity = entity {
            entity.name = name
            entity.date = date
            entity.kindEntity = kind
        }
        
        save()
    }
    
    func isDisabled() -> Bool {
        return name == "" || kind == nil
    }
    
    func getKindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntitys \(error)")
        }
    }
    
    func save() {
        manager.save()
        getKindEntitys()
    }
}
