//
//  TodoEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 20/08/2021.
//

import UIKit
import CoreData

extension TodoEntity: Comparable {
    public override func prepareForDeletion() {
        super.prepareForDeletion()
        guard let event = event else { return }
        let entities = event.entities?.allObjects as? [TodoEntity]
        guard let entities = entities else { return }
        if entities.count <= 1 {
            CoreDataManager.instance.context.delete(event)
            print("delete event by prepareDeletion")
        }
    }
    
    public static func < (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        (lhs.name ?? "") > (rhs.name ?? "")
    }
}
