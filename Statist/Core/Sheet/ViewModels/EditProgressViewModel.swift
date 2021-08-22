////
////  EditProgressView.swift
////  Statist
////
////  Created by Kimyaehoon on 21/07/2021.
////
//
//import Foundation
//import CoreData
//
//class EditProgressViewModel: ObservableObject {
//    @Published var name = ""
//    @Published var goal: Float = 0
//    @Published var selectedKind: KindEntity?
//    
//    @Published var kinds: [KindEntity] = []
//    @Published var showAddKindView: Bool = false
//    var entity: ProgressEntity?
//    
//    let manager = CoreDataManager.instance
//    
//    init(entity: ProgressEntity?) {
//        self.entity = entity
//        self.name = entity?.name ?? ""
//        self.goal = Float(entity?.goal ?? 0)
//        self.selectedKind = entity?.kindEntity
//        getKindEntitys()
//    }
//    
//    func isDisabled() -> Bool {
//        return name == "" || selectedKind == nil || Int(goal) <= entity?.progressPoints?.count ?? 0
//    }
//    
//    func getKindEntitys() {
//        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
//        do {
//            kinds = try manager.context.fetch(request)
//        } catch let error {
//            print("Error Fetching KindEntitys \(error)")
//        }
//    }
//    
//    func updateProgressEntity() {
//        if let entity = entity {
//            entity.name = name
//            entity.kindEntity = selectedKind
//            entity.goal = Int16(goal)
//        }
//        save()
//    }
//    
//    func save() {
//        manager.save()
//        getKindEntitys()
//    }
//}
