//
//  TodoItem.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI

struct TodoItem {
    let id = UUID().uuidString
    var description: String
    var kind: Kind
    var isDone = false
    
    init(_ description: String = "", kind: Kind){
        self.description = description
        self.kind = kind
    }
}
