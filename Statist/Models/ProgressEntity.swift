//
//  ProgressEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 20/07/2021.
//

import Foundation

extension ProgressEntity {
    var percent: Int {
        return Int(Float(self.now) / Float(self.goal) * 100)
    }
    
    var now: Int {
        let data = getProgressPoints()
        return data.reduce(0) { result, point in
            return result + Int(point.count)
        }
    }
    
    var isFinish: Bool {
        return self.now >= Int(self.goal)
    }
    
    var isNotFinish: Bool {
        return !isFinish
    }
    
    func getProgressPoints() -> [ProgressPoint] {
        return self.progressPoints?.allObjects as? [ProgressPoint] ?? []
    }
    
    func findPoint(_ date: Date) -> ProgressPoint? {
        let data = getProgressPoints()
        return data.first(where: { $0.date == date })
    }
}
