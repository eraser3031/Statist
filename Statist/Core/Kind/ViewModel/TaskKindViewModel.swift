//
//  TaskKindViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 12/08/2021.
//

import SwiftUI

class TaskKindViewModel: ObservableObject {
    
    let kind: KindEntity?
    let kinds: [KindEntity]
    @Published var text = ""
    @Published var color: ColorKind?
    var isEdit: Bool = false
    
    @Published var alertDelete = false
    
    let manager = CoreDataManager.instance
    
    var isOverlap: Bool {
        return kinds.first {($0.name ?? "") == text} != nil
    }
    
    var isDisabled: Bool {
        return text == "" || color == nil || isOverlap
    }
    
    init(_ kind: KindEntity?, kinds: [KindEntity]) {
        self.kind = kind
        if let kind = kind {
            self.kinds = kinds.filter{($0.name ?? "") != (kind.name ?? "") }
        } else {
            self.kinds = kinds
        }
        
        if let kind = kind {
            text = kind.name ?? ""
            color = kind.color
            isEdit = true
        }
    }
    
    func addKindEntity() {
        let newEntity = KindEntity(context: manager.context)
        newEntity.id = UUID().uuidString
        newEntity.name = text
        newEntity.colorKindID = color?.id ?? "blue"
        
        newEntity.goalEntities = []
        newEntity.todoEntities = []
        newEntity.timetableEntities = []
        print(newEntity)
    }
    
    func editKindEntity() {
        guard let kind = kind else { return }
        kind.name = text
        kind.colorKindID = color?.id ?? "blue"
        print(kind)
    }
    
    func deleteKindEntity() {
        guard let kind = kind else { return }
        
//        let todoes = kind.todolistEntitys?.allObjects as? [TodoListEntity] ?? []
//        let timetables = kind.timetableEntitys?.allObjects as? [TimetableEntity] ?? []
//        let progresses = kind.progressEntitys?.allObjects as? [ProgressEntity] ?? []
//        
//        todoes.forEach { todo in
//            manager.context.delete(todo)
//        }
//        
//        timetables.forEach { timetable in
//            manager.context.delete(timetable)
//        }
//        
//        progresses.forEach { progress in
//            manager.context.delete(progress)
//        }
        
        manager.context.delete(kind)
    }
}
