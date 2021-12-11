//
//  CoreDataManager.swift
//  Statist
//
//  Created by Kimyaehoon on 10/07/2021.
//

import SwiftUI
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            print("preview error")
        }
        return result
    }()
    
    //    let container: NSPersistentContainer
    let container: NSPersistentCloudKitContainer
    let context: NSManagedObjectContext
    //    let childContext: NSManagedObjectContext
    //    var user: UserEntity?
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "UserDataContainer")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data \(error)")
            }
        }
        context = container.viewContext
        context.automaticallyMergesChangesFromParent = true //
        
        //        childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //        childContext.parent = container.viewContext
        
        userEntity()
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data \(error)")
        }
    }
    
    func userEntity() {
        //        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        //        do {
        //            let result = try context.fetch(request)
        //            if let userResult = result.first {
        //                user = userResult
        //            } else {
        //                let tempUser = UserEntity(context: context)
        //                tempUser.id = UUID().uuidString
        //                tempUser.name = "Yaehoon Kim"
        //                tempUser.thumbnailData = UIImage(named: "TempThumbnail")?.jpegData(compressionQuality: 1)
        //
        //                save()
        //
        //                user = tempUser
        //            }
        //        } catch let error {
        //            print("Error Fetching UserEntitys in \(#function): \(error)")
        //        }
    }
}
