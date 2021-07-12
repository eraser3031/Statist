//
//  PlanModel.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI

class PlanModel {
    
    typealias DateTerm = (start: Date, end: Date)
    
    let id = UUID().uuidString
    let date: Date
    
    @Published var todoList: [TodoItem] = []
    @Published var timeTable: [DateTerm] = []
    
    init(date: Date) {
        self.date = date
    }
}
