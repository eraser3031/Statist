//
//  ProgressModel.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct ProgressModel {
    let id = UUID().uuidString
    var kind: Kind
    var name: String
    var goal: Int
    var records: [Date]
    
    var now: Int {
        return records.count
    }
    
    var percentage: Float {
        return Float(now) / Float(goal) * 100
    }
    // (data.height, specifier: "%.2f")
}
