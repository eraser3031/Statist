//
//  ProgressEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 20/07/2021.
//

import Foundation

extension ProgressEntity {
    var percent: Int {
        return Int(Float(self.progressPoints?.count ?? 0) / Float(self.goal) * 100)
    }
    
    var now: Int {
        return self.progressPoints?.count ?? 0
    }
}
