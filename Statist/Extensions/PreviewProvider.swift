//
//  PreviewProvider.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import Foundation
import SwiftUI
import CoreData

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
//        let manager = CoreDataManager.instance
//        
//        let study = KindEntity(context: manager.context)
//        study.name = "study"
//        study.id = UUID().uuidString
//        study.colorKindID = "purple"
//        study.todoListEntitys = []
//        study.progressEntitys = []
//        study.timeTableEntitys = []
//        
//        let guitar = KindEntity(context: manager.context)
//        guitar.name = "guitar"
//        guitar.id = UUID().uuidString
//        guitar.colorKindID = "pink"
//        guitar.todoListEntitys = []
//        guitar.progressEntitys = []
//        guitar.timeTableEntitys = []
//        
//        let entity = TodoListEntity(context: manager.context)
//        entity.name = "test data name"
//        entity.id = UUID().uuidString
//        entity.isDone = false
//        entity.kindEntity = study
//        do {
//            try manager.context.save()
//        } catch let error {
//            print("why...")
//        }
    }
}
