//
//  CoreDataManager.swift
//  Statist
//
//  Created by Kimyaehoon on 10/07/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    static var preview: CoreDataManager {
        let result = CoreDataManager(inMemory: true)
        let context = result.container.viewContext
        
        for i in 0..<3 {
            let newItem = KindEntity(context: context)
            newItem.name = i == 1 ? "Study" : i == 2 ? "Guitar" : "Exercise"
            newItem.id = UUID().uuidString
            newItem.colorKindID = i == 1 ? "blue" : i == 2 ? "purple" : "red"
        }
        
        do {
            try context.save()
        } catch let error {
            print("Error Testing Data \(error)")
        }
        
        return result
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "UserDataContainer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data \(error)")
        }
    }
}
