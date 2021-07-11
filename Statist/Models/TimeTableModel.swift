//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI

struct TimeTableModel {
    let id = UUID().uuidString
    var description: String
    var kind: Kind
    var start: Date
    var end: Date
    
    init(_ description: String = "", kind: Kind, start: Date, end: Date){
        self.description = description
        self.kind = kind
        self.start = start
        self.end = end
    }
}
