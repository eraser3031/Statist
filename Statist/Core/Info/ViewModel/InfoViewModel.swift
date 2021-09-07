//
//  InfoViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 30/08/2021.
//

import Foundation
import SwiftUI
import CoreData

class InfoViewModel: ObservableObject {
    
    @Published var info: InfoEntity?
    
    var mananger = CoreDataManager.instance
    
    init() {
        entity()
    }
    
    func entity() {
        let request = NSFetchRequest<InfoEntity>(entityName: "InfoEntity")
        do {
            let result = try mananger.context.fetch(request)
            if result.count == 0 {
                let newEntity = InfoEntity(context: mananger.context)
                newEntity.thumbnail = UIImage(named: "TempThumbnail")?.jpegData(compressionQuality: 0.5)
                newEntity.name = "Write Your Name"
                mananger.save()
                info = newEntity
                
            } else if result.count == 1 {
                info = result.first!
                
            } else if result.count > 1 {
                for (index, entity) in result.enumerated() {
                    if index == result.endIndex - 1 {
                        info = result[index]
                    } else {
                        mananger.context.delete(entity)
                    }
                }
            }
        } catch let error {
            fatalError("Error fetching Info Entity in InfoViewModel: \(error)")
        }
    }
    
    func updateName(_ name: String) {
        info?.name = name
        saveAndLoad()
    }
    
    func updateThumbnail(_ thumbnail: Data) {
        info?.thumbnail = thumbnail
        saveAndLoad()
    }
    
    private func saveAndLoad() {
        mananger.save()
        entity()
    }
}

class SettingViewModel: ObservableObject {
    
    var mananger = CoreDataManager.instance
    var kinds: [KindEntity] = []
    
    init() {
        KindEntities()
    }
    
    func KindEntities() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try mananger.context.fetch(request)
        } catch let error {
            fatalError("Error fetching Kind Entities in SettingViewModel: \(error)")
        }
    }
    
    func clearAll() {
        kinds.forEach({ mananger.context.delete($0) })
        saveAndLoad()
    }
    
    private func saveAndLoad() {
        mananger.save()
        KindEntities()
    }
}
