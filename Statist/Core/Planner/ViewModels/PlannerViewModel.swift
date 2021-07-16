//
//  PlannerViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 09/07/2021.
//

import SwiftUI
import Combine
import CoreData

class PlannerViewModel: ObservableObject {
    
    @Published var pickedItem: PickerItemOption = .TodoList
    @Published var calendarScope: Bool = false
    @Published var rect: CGRect = CGRect()
    
//    let manager = CoreDataManager.instance
    
    var cancellables = Set<AnyCancellable>()
    
//    func getDateData() {
//        let request = NSFetchRequest<TodoListEntity>(entityName: "??")
//    }
}
