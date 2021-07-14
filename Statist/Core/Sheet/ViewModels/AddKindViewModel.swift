//
//  AddTodoViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI
import CoreData

class AddKindViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var kinds: [KindEntity] = []
    @Published var colorKind: ColorKind?
    
    var isOverlap: Bool {
        return kinds.first {($0.name ?? "") == name} != nil
    }
    
    let manager = CoreDataManager.instance
    
    init() {
        getKindEntitys()
    }
    
    func isDisabled() -> Bool {
        return name == "" || colorKind == nil || isOverlap
    }
    
    func getKindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntitys \(error)")
        }
    }
    
    func addKindEntity() {
        let newKind = KindEntity(context: manager.context)
        newKind.id = UUID().uuidString
        newKind.name = name
        newKind.colorKindID = colorKind?.id ?? "blue"
        newKind.todoListEntitys = []
        newKind.timeTableEntitys = []
        newKind.progressEntitys = []
        
        save()
    }
    
    func save() {
        manager.save()
        getKindEntitys()
    }
}
