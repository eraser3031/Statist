//
//  KindPickerViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import Foundation
import CoreData

class KindPickerViewModel: ObservableObject {
    
    @Published var kinds: [KindEntity] = []
    @Published var selectedKind: KindEntity?
    @Published var showAddKindView = false
    
    let manager = CoreDataManager.instance
    
    init(){
        getKindEntitys()
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
    
    func isSelected(kind: KindEntity) -> Bool {
        if let selectedKind = selectedKind {
            return (selectedKind.id ?? "") == (kind.id ?? "/")
        } else {
            return false
        }
    }
}
