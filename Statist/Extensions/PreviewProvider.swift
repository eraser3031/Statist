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
    
    var kind1 = Kind(name: "개발", color: .purple)
    var kind2 = Kind(name: "기타", color: .red)
    var kind3 = Kind(name: "일본어", color: .green)
    
    
    var todoModel1 = TodoModel("WWDC21 Formatter 강의 듣기", kind: Kind(name: "개발", color: .purple))
    var todoModel2 = TodoModel("김민태의 프론트엔드 강의 2개 학습", kind: Kind(name: "개발", color: .purple))
    var todoModel3 = TodoModel("솔로 파트 연습", kind: Kind(name: "기타", color: .red))
    var todoModel4 = TodoModel("단어 복습 후 20개 암기", kind: Kind(name: "일본어", color: .green))
}
