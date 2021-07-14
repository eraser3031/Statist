//
//  AddTodoViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI

class AddTodoViewModel: ObservableObject {
    @Published var date: Date
    @Published var name: String = ""
    @Published var selectedKind: KindEntity?
    
    init(date: Date) {
        self.date = date
    }
    
    func isDisabled() -> Bool {
        return name == "" || selectedKind == nil
    }
}
