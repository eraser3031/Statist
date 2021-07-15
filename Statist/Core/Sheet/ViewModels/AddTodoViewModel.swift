//
//  AddTodoViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI
import CoreData

class AddTodoViewModel: ObservableObject {
    @Published var date: Date
    @Published var name: String = ""
    @Published var kinds: [KindEntity] = []
    @Published var selectedKind: KindEntity?
    @Published var showAddKindView: Bool = false
    
    let manager = CoreDataManager.instance
    
    init(date: Date) {
        self.date = date
        getKindEntitys()
    }
    
    func isDisabled() -> Bool {
        return name == "" || selectedKind == nil
    }
    
    func getKindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntitys \(error)")
        }
    }
    
    func addTodoListEntity() {
        let newTodoList = TodoListEntity(context: manager.context)
        newTodoList.id = UUID().uuidString
        newTodoList.name = name
        newTodoList.kindEntity = selectedKind
        newTodoList.isDone = false
        newTodoList.date = date
        save()
    }
    
    func save() {
        manager.save()
        getKindEntitys()
    }
}
