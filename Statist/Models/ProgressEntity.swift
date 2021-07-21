//
//  ProgressEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 20/07/2021.
//

import Foundation

extension ProgressEntity {
    var percent: Int {
        return (self.progressPoints?.count ?? 0) / Int(self.goal)
    }
    
    var now: Int {
        return self.progressPoints?.count ?? 0
    }
}
