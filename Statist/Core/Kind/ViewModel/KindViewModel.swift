//
//  KindViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 11/08/2021.
//

import Foundation
import CoreData

class KindViewModel: ObservableObject {
    
    @Published var kinds: [KindEntity] = []
    
    @Published var text: String = ""
    @Published var color: ColorKind?
    
    let manager = CoreDataManager.instance
    
    init(){
        kindEntitys()
    }
    
    func kindEntitys() {
        let request = NSFetchRequest<KindEntity>(entityName: "KindEntity")
        do {
            kinds = try manager.context.fetch(request)
        } catch let error {
            print("Error Fetching KindEntitys \(error)")
        }
    }
    
    func save() {
        manager.save()
        kindEntitys()
    }
}
